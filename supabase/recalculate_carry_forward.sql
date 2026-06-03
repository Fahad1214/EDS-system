-- Paste this entire file into Supabase → SQL Editor → Run
-- Fixes: "Could not find the function public.recalculate_carry_forward"

create or replace function public.monthly_record_gross_due(
  tuition numeric,
  other_charges numeric,
  annual_fund numeric,
  carry_forward numeric
)
returns numeric
language sql
immutable
as $$
  select coalesce(tuition, 0) + coalesce(other_charges, 0) + coalesce(annual_fund, 0) + coalesce(carry_forward, 0);
$$;

create or replace function public.recalculate_carry_forward(year_value integer)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.monthly_fee_records mfr
  set carry_forward_amount = coalesce(previous_month.arrears_amount, 0),
      total_due = public.monthly_record_gross_due(
        mfr.tuition_amount,
        mfr.other_charges,
        mfr.annual_fund_amount,
        coalesce(previous_month.arrears_amount, 0)
      ),
      arrears_amount = greatest(
        public.monthly_record_gross_due(
          mfr.tuition_amount,
          mfr.other_charges,
          mfr.annual_fund_amount,
          coalesce(previous_month.arrears_amount, 0)
        ) - mfr.amount_received,
        0
      )
  from public.fee_cycles current_cycle
  left join lateral (
    select mfr_prev.arrears_amount
    from public.monthly_fee_records mfr_prev
    join public.fee_cycles fc_prev on fc_prev.id = mfr_prev.fee_cycle_id
    where mfr_prev.family_id = mfr.family_id
      and fc_prev.month_key < current_cycle.month_key
    order by fc_prev.month_key desc
    limit 1
  ) previous_month on true
  where current_cycle.id = mfr.fee_cycle_id
    and extract(year from current_cycle.month_key) = year_value;
end;
$$;

grant execute on function public.recalculate_carry_forward(integer) to anon, authenticated;
grant execute on function public.recalculate_carry_forward(integer) to service_role;

-- Run once after months exist:
select public.recalculate_carry_forward(2023);
