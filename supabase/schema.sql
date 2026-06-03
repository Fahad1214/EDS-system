create extension if not exists "pgcrypto";

create table if not exists public.families (
  id uuid primary key default gen_random_uuid(),
  family_code text not null unique,
  legacy_family_number text,
  guardian_name text not null,
  phone text,
  address text,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.students (
  id uuid primary key default gen_random_uuid(),
  family_id uuid not null references public.families(id) on delete cascade,
  student_name text not null,
  class_name text,
  monthly_fee numeric(12,2) not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.fee_cycles (
  id uuid primary key default gen_random_uuid(),
  month_key date not null unique,
  label text not null,
  due_date date,
  status text not null default 'open' check (status in ('open', 'closed')),
  created_at timestamptz not null default now()
);

create table if not exists public.monthly_fee_records (
  id uuid primary key default gen_random_uuid(),
  family_id uuid not null references public.families(id) on delete cascade,
  fee_cycle_id uuid not null references public.fee_cycles(id) on delete cascade,
  tuition_amount numeric(12,2) not null default 0,
  other_charges numeric(12,2) not null default 0,
  annual_fund_amount numeric(12,2) not null default 0,
  carry_forward_amount numeric(12,2) not null default 0,
  total_due numeric(12,2) not null default 0,
  amount_received numeric(12,2) not null default 0,
  arrears_amount numeric(12,2) not null default 0,
  note text,
  created_at timestamptz not null default now(),
  unique (family_id, fee_cycle_id)
);

alter table public.monthly_fee_records
  add column if not exists annual_fund_amount numeric(12,2) not null default 0;

create table if not exists public.payments (
  id uuid primary key default gen_random_uuid(),
  monthly_fee_record_id uuid not null references public.monthly_fee_records(id) on delete cascade,
  amount numeric(12,2) not null,
  payment_date date not null default current_date,
  payment_method text,
  reference_no text,
  note text,
  created_at timestamptz not null default now()
);

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

create or replace function public.refresh_monthly_fee_totals()
returns trigger
language plpgsql
as $$
declare
  target_record_id uuid;
  gross_due numeric(12,2);
  received numeric(12,2);
begin
  if tg_op = 'DELETE' then
    target_record_id := old.monthly_fee_record_id;
  else
    target_record_id := new.monthly_fee_record_id;
  end if;

  select
    public.monthly_record_gross_due(
      mfr.tuition_amount,
      mfr.other_charges,
      mfr.annual_fund_amount,
      mfr.carry_forward_amount
    ),
    coalesce((
      select sum(p.amount)
      from public.payments p
      where p.monthly_fee_record_id = target_record_id
    ), 0)
  into gross_due, received
  from public.monthly_fee_records mfr
  where mfr.id = target_record_id;

  update public.monthly_fee_records
  set amount_received = received,
      total_due = gross_due,
      arrears_amount = greatest(gross_due - received, 0)
  where id = target_record_id;

  return coalesce(new, old);
end;
$$;

drop trigger if exists payments_refresh_monthly_fee_totals on public.payments;

create trigger payments_refresh_monthly_fee_totals
after insert or update or delete on public.payments
for each row execute function public.refresh_monthly_fee_totals();

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

-- Re-link carry-forward from the previous calendar month (run after bulk-creating months).
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
