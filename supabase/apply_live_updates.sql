-- Run once in Supabase SQL Editor on an existing project to sync functions with the app.

alter table public.monthly_fee_records
  add column if not exists annual_fund_amount numeric(12,2) not null default 0;

-- Paste the function definitions from schema.sql:
-- monthly_record_gross_due, refresh_monthly_fee_totals, create_next_fee_cycle
-- Then run seed_fee_cycles_2023.sql to add missing months.

grant execute on function public.create_next_fee_cycle(date, text, date) to anon, authenticated;
