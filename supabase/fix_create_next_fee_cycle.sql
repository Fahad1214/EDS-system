-- Run in Supabase SQL Editor if you see:
-- duplicate key value violates unique constraint "fee_cycles_month_key_key"

create or replace function public.create_next_fee_cycle(next_month date, next_label text, next_due_date date)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  created_cycle_id uuid;
  target_month date := date_trunc('month', next_month)::date;
begin
  insert into public.fee_cycles (month_key, label, due_date)
  values (target_month, next_label, next_due_date)
  on conflict (month_key) do update
    set label = excluded.label,
        due_date = excluded.due_date
  returning id into created_cycle_id;

  insert into public.monthly_fee_records (
    family_id,
    fee_cycle_id,
    tuition_amount,
    other_charges,
    annual_fund_amount,
    carry_forward_amount,
    total_due,
    amount_received,
    arrears_amount
  )
  select
    f.id,
    created_cycle_id,
    coalesce(sum(s.monthly_fee), 0) as tuition_amount,
    0 as other_charges,
    0 as annual_fund_amount,
    coalesce(previous_record.arrears_amount, 0) as carry_forward_amount,
    public.monthly_record_gross_due(
      coalesce(sum(s.monthly_fee), 0),
      0,
      0,
      coalesce(previous_record.arrears_amount, 0)
    ) as total_due,
    0 as amount_received,
    public.monthly_record_gross_due(
      coalesce(sum(s.monthly_fee), 0),
      0,
      0,
      coalesce(previous_record.arrears_amount, 0)
    ) as arrears_amount
  from public.families f
  left join public.students s on s.family_id = f.id and s.is_active = true
  left join lateral (
    select mfr.arrears_amount
    from public.monthly_fee_records mfr
    join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
    where mfr.family_id = f.id
      and fc.month_key < target_month
    order by fc.month_key desc
    limit 1
  ) previous_record on true
  where f.is_active = true
  group by f.id, previous_record.arrears_amount
  on conflict (family_id, fee_cycle_id) do nothing;

  return created_cycle_id;
end;
$$;

grant execute on function public.create_next_fee_cycle(date, text, date) to anon, authenticated;
