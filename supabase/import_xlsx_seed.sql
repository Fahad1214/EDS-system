-- One-time import generated from Styled_March_Fee_2023.xlsx
-- Paste into the Supabase SQL Editor and run once.
begin;

insert into public.fee_cycles (month_key, label, due_date, status)
values (date '2023-03-01', 'March 2023', date '2023-03-10', 'open')
on conflict (month_key) do update
set label = excluded.label,
    due_date = excluded.due_date;

-- Abdul Rauf / 71
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0001', '71', 'Abdul Rauf', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0001' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  7500.00,
  0.00,
  0.00,
  7500.00,
  0.00,
  7500.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Ahmad', null, 1500.00, true
from public.families
where family_code = 'EGSS-FAM-0001';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Luqman', null, 1500.00, true
from public.families
where family_code = 'EGSS-FAM-0001';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Abiha', null, 1500.00, true
from public.families
where family_code = 'EGSS-FAM-0001';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Laiba Noor', null, 1500.00, true
from public.families
where family_code = 'EGSS-FAM-0001';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Arbaz', null, 1500.00, true
from public.families
where family_code = 'EGSS-FAM-0001';

-- M.Tayyab / 69
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0002', '69', 'M.Tayyab', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0002' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  6900.00,
  10000.00,
  0.00,
  16900.00,
  5800.00,
  11100.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Shukran', null, 1725.00, true
from public.families
where family_code = 'EGSS-FAM-0002';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Talha', null, 1725.00, true
from public.families
where family_code = 'EGSS-FAM-0002';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Tamazir Fatima', null, 1725.00, true
from public.families
where family_code = 'EGSS-FAM-0002';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Meerab', null, 1725.00, true
from public.families
where family_code = 'EGSS-FAM-0002';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 5800.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0002'
  and fc.month_key = date '2023-03-01';

-- M.Afzaal / 25
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0003', '25', 'M.Afzaal', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0003' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3400.00,
  0.00,
  0.00,
  3400.00,
  3400.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Zain Afzaal', null, 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0003';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Saim', null, 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0003';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 3400.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0003'
  and fc.month_key = date '2023-03-01';

-- Asif Javeed Khan / 46
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0004', '46', 'Asif Javeed Khan', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0004' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  7700.00,
  12200.00,
  0.00,
  19900.00,
  7700.00,
  12200.00,
  'Sheet Total Amount: 7700'
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Minahil', null, 1925.00, true
from public.families
where family_code = 'EGSS-FAM-0004';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Abdul.Manan Khan', null, 1925.00, true
from public.families
where family_code = 'EGSS-FAM-0004';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Asadullah Khan', null, 1925.00, true
from public.families
where family_code = 'EGSS-FAM-0004';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Abdullah Khan', null, 1925.00, true
from public.families
where family_code = 'EGSS-FAM-0004';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 7700.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0004'
  and fc.month_key = date '2023-03-01';

-- Azeem Asghar / 48
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0005', '48', 'Azeem Asghar', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0005' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  4700.00,
  1000.00,
  9000.00,
  14700.00,
  0.00,
  14700.00,
  'Sheet Total Amount: 9000'
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Yazan', null, 1566.66, true
from public.families
where family_code = 'EGSS-FAM-0005';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Rehan', null, 1566.66, true
from public.families
where family_code = 'EGSS-FAM-0005';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Urooj Fatima', null, 1566.68, true
from public.families
where family_code = 'EGSS-FAM-0005';

-- Mehdi Hassan / 53
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0006', '53', 'Mehdi Hassan', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0006' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  4000.00,
  500.00,
  0.00,
  4500.00,
  3600.00,
  900.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Ayan Ali', null, 2000.00, true
from public.families
where family_code = 'EGSS-FAM-0006';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Eshal Fatima', null, 2000.00, true
from public.families
where family_code = 'EGSS-FAM-0006';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 3600.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0006'
  and fc.month_key = date '2023-03-01';

-- Sohail Ahmad Khan / 62
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0007', '62', 'Sohail Ahmad Khan', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0007' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  5700.00,
  0.00,
  0.00,
  5700.00,
  5700.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Minha', null, 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0007';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Kinza', null, 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0007';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Anaya', null, 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0007';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 5700.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0007'
  and fc.month_key = date '2023-03-01';

-- Saifullah / 29
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0008', '29', 'Saifullah', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0008' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  4000.00,
  0.00,
  0.00,
  4000.00,
  0.00,
  4000.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Azan', null, 2000.00, true
from public.families
where family_code = 'EGSS-FAM-0008';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Arham', null, 2000.00, true
from public.families
where family_code = 'EGSS-FAM-0008';

-- Nayyer Hafeez / 26
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0009', '26', 'Nayyer Hafeez', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0009' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  5400.00,
  0.00,
  0.00,
  5400.00,
  5000.00,
  400.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Umer', null, 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0009';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Hafsa', null, 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0009';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Arfa Nayyar', null, 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0009';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 5000.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0009'
  and fc.month_key = date '2023-03-01';

-- Asfand Yar / 1
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0010', '1', 'Asfand Yar', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0010' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3800.00,
  0.00,
  0.00,
  3800.00,
  3400.00,
  400.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Anaya Fatima', null, 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0010';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Moez Khan', null, 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0010';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 3400.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0010'
  and fc.month_key = date '2023-03-01';

-- Abdul.Manan / 16
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0011', '16', 'Abdul.Manan', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0011' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  5500.00,
  0.00,
  0.00,
  5500.00,
  5500.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Hisham', null, 1833.33, true
from public.families
where family_code = 'EGSS-FAM-0011';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Hussan Sultan', null, 1833.33, true
from public.families
where family_code = 'EGSS-FAM-0011';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Eshal Fatima', null, 1833.34, true
from public.families
where family_code = 'EGSS-FAM-0011';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 5500.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0011'
  and fc.month_key = date '2023-03-01';

-- Shakeel Ahmad / 85
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0012', '85', 'Shakeel Ahmad', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0012' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  5200.00,
  0.00,
  0.00,
  5200.00,
  5000.00,
  200.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Khadija Shakeela', null, 1733.33, true
from public.families
where family_code = 'EGSS-FAM-0012';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Ayesha', null, 1733.33, true
from public.families
where family_code = 'EGSS-FAM-0012';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Sharjeel Shakeel', null, 1733.34, true
from public.families
where family_code = 'EGSS-FAM-0012';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 5000.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0012'
  and fc.month_key = date '2023-03-01';

-- M.Yasir / 52
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0013', '52', 'M.Yasir', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0013' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3800.00,
  0.00,
  0.00,
  3800.00,
  3600.00,
  200.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Zainab Yasir', null, 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0013';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Hamza Yasir', null, 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0013';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 3600.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0013'
  and fc.month_key = date '2023-03-01';

-- Zaheer Ahmad / 34
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0014', '34', 'Zaheer Ahmad', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0014' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1900.00,
  4980.00,
  0.00,
  6880.00,
  0.00,
  6880.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Samara', null, 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0014';

-- Niamat Ali / 80
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0015', '80', 'Niamat Ali', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0015' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1850.00,
  4830.00,
  0.00,
  6680.00,
  0.00,
  6680.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Suleman', null, 1850.00, true
from public.families
where family_code = 'EGSS-FAM-0015';

-- Allah Ditta / 80
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0016', '80', 'Allah Ditta', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0016' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  4900.00,
  0.00,
  3000.00,
  7900.00,
  4900.00,
  3000.00,
  'Sheet Total Amount: 4900'
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Fajar', null, 1633.33, true
from public.families
where family_code = 'EGSS-FAM-0016';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Mohsin Ali', null, 1633.33, true
from public.families
where family_code = 'EGSS-FAM-0016';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Unar', null, 1633.34, true
from public.families
where family_code = 'EGSS-FAM-0016';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 4900.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0016'
  and fc.month_key = date '2023-03-01';

-- Waseem Saleem / 75
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0017', '75', 'Waseem Saleem', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0017' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3800.00,
  0.00,
  0.00,
  3800.00,
  3800.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Eshal Fatima', null, 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0017';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Arham', null, 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0017';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 3800.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0017'
  and fc.month_key = date '2023-03-01';

-- Khuram Butt,Shakeel Butt / 90
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0018', '90', 'Khuram Butt,Shakeel Butt', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0018' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  5000.00,
  0.00,
  0.00,
  5000.00,
  5000.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Dua Fatima', null, 2500.00, true
from public.families
where family_code = 'EGSS-FAM-0018';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Jannat Fatima', null, 2500.00, true
from public.families
where family_code = 'EGSS-FAM-0018';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 5000.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0018'
  and fc.month_key = date '2023-03-01';

-- M.Aslam / 77
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0019', '77', 'M.Aslam', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0019' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3700.00,
  0.00,
  0.00,
  3700.00,
  3700.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Zubda Aslam', null, 1850.00, true
from public.families
where family_code = 'EGSS-FAM-0019';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Amina Aslam', null, 1850.00, true
from public.families
where family_code = 'EGSS-FAM-0019';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 3700.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0019'
  and fc.month_key = date '2023-03-01';

-- Rana Raiz / 81
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0020', '81', 'Rana Raiz', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0020' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3900.00,
  0.00,
  0.00,
  3900.00,
  0.00,
  3900.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Kanwal Riaz', null, 1950.00, true
from public.families
where family_code = 'EGSS-FAM-0020';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Insha Riaz', null, 1950.00, true
from public.families
where family_code = 'EGSS-FAM-0020';

-- Ghulam Shabir / 9
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0021', '9', 'Ghulam Shabir', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0021' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  2900.00,
  0.00,
  3030.00,
  5930.00,
  0.00,
  5930.00,
  'Sheet Total Amount: 2900'
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Abdul Ahad', null, 1450.00, true
from public.families
where family_code = 'EGSS-FAM-0021';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Aiza', null, 1450.00, true
from public.families
where family_code = 'EGSS-FAM-0021';

-- Ameer Umer / 23
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0022', '23', 'Ameer Umer', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0022' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  5600.00,
  0.00,
  0.00,
  5600.00,
  5000.00,
  600.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Rehan Ali', null, 1866.66, true
from public.families
where family_code = 'EGSS-FAM-0022';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Armish', null, 1866.66, true
from public.families
where family_code = 'EGSS-FAM-0022';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Raffey Hussain', null, 1866.68, true
from public.families
where family_code = 'EGSS-FAM-0022';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 5000.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0022'
  and fc.month_key = date '2023-03-01';

-- M.Saeed / 18
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0023', '18', 'M.Saeed', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0023' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3300.00,
  6520.00,
  0.00,
  9820.00,
  3000.00,
  6820.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Hassan', null, 1650.00, true
from public.families
where family_code = 'EGSS-FAM-0023';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Hisham', null, 1650.00, true
from public.families
where family_code = 'EGSS-FAM-0023';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 3000.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0023'
  and fc.month_key = date '2023-03-01';

-- Abdul Rehman / 45
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0024', '45', 'Abdul Rehman', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0024' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3800.00,
  10200.00,
  0.00,
  14000.00,
  0.00,
  14000.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Jawad Khan', null, 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0024';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Hania Abdul Rehman', null, 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0024';

-- Abdul Rauf / 88
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0025', '88', 'Abdul Rauf', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0025' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  5900.00,
  0.00,
  0.00,
  5900.00,
  0.00,
  5900.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Abdul Rehman', null, 1966.66, true
from public.families
where family_code = 'EGSS-FAM-0025';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Abdul Rauf', null, 1966.66, true
from public.families
where family_code = 'EGSS-FAM-0025';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Abdullah Khalid', null, 1966.68, true
from public.families
where family_code = 'EGSS-FAM-0025';

-- Nazir Ahmad / 55
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0026', '55', 'Nazir Ahmad', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0026' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  6500.00,
  0.00,
  7820.00,
  14320.00,
  0.00,
  14320.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Mehak Nazir', null, 1625.00, true
from public.families
where family_code = 'EGSS-FAM-0026';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Sabiha', null, 1625.00, true
from public.families
where family_code = 'EGSS-FAM-0026';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Hamza', null, 1625.00, true
from public.families
where family_code = 'EGSS-FAM-0026';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Nabeela Nazir', null, 1625.00, true
from public.families
where family_code = 'EGSS-FAM-0026';

-- M.Irfan / 27
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0027', '27', 'M.Irfan', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0027' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  8500.00,
  15760.00,
  0.00,
  24260.00,
  0.00,
  24260.00,
  'Sheet Total Amount: 8500'
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Hamza Irfan', null, 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0027';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Esha Noor', null, 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0027';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Ahmad', null, 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0027';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Sawaira', null, 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0027';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Saba', null, 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0027';

-- M.Ashfaq / 39
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0028', '39', 'M.Ashfaq', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0028' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  6000.00,
  0.00,
  20960.00,
  26960.00,
  7080.00,
  19880.00,
  'Sheet Total Amount: 1300'
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Zeeshan', null, 1500.00, true
from public.families
where family_code = 'EGSS-FAM-0028';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Usman', null, 1500.00, true
from public.families
where family_code = 'EGSS-FAM-0028';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Faizan', null, 1500.00, true
from public.families
where family_code = 'EGSS-FAM-0028';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Subhan', null, 1500.00, true
from public.families
where family_code = 'EGSS-FAM-0028';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 7080.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0028'
  and fc.month_key = date '2023-03-01';

-- M.Saleem Khan / 94
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0029', '94', 'M.Saleem Khan', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0029' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1800.00,
  950.00,
  1600.00,
  4350.00,
  0.00,
  4350.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Meer Zman', null, 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0029';

-- Waseem Barkat / 51
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0030', '51', 'Waseem Barkat', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0030' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  4300.00,
  0.00,
  0.00,
  4300.00,
  0.00,
  4300.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Ayman Bibi', null, 2150.00, true
from public.families
where family_code = 'EGSS-FAM-0030';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Um-e-Habiba', null, 2150.00, true
from public.families
where family_code = 'EGSS-FAM-0030';

-- Liaquat Ali / 22
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0031', '22', 'Liaquat Ali', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0031' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1900.00,
  3630.00,
  1700.00,
  7230.00,
  0.00,
  7230.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Ayar', null, 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0031';

-- Ilyas Ali / 50
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0032', '50', 'Ilyas Ali', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0032' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3000.00,
  11530.00,
  0.00,
  14530.00,
  0.00,
  14530.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Fiza Fatima', null, 750.00, true
from public.families
where family_code = 'EGSS-FAM-0032';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M', null, 750.00, true
from public.families
where family_code = 'EGSS-FAM-0032';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Uzair Ali', null, 750.00, true
from public.families
where family_code = 'EGSS-FAM-0032';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Salar Haider', null, 750.00, true
from public.families
where family_code = 'EGSS-FAM-0032';

-- Asad Bilal / 68
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0033', '68', 'Asad Bilal', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0033' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3600.00,
  0.00,
  0.00,
  3600.00,
  0.00,
  3600.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Moez Bilal', null, 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0033';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Muneeb Bilal', null, 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0033';

-- Nazar Abbas / 28
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0034', '28', 'Nazar Abbas', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0034' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  7000.00,
  0.00,
  0.00,
  7000.00,
  6600.00,
  400.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Rameen Sadam', null, 1750.00, true
from public.families
where family_code = 'EGSS-FAM-0034';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Rabia Sadam', null, 1750.00, true
from public.families
where family_code = 'EGSS-FAM-0034';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Mahnoor', null, 1750.00, true
from public.families
where family_code = 'EGSS-FAM-0034';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Maham Shahzadi', null, 1750.00, true
from public.families
where family_code = 'EGSS-FAM-0034';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 6600.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0034'
  and fc.month_key = date '2023-03-01';

-- Rashid Ali / 47
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0035', '47', 'Rashid Ali', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0035' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1600.00,
  0.00,
  1930.00,
  3530.00,
  1600.00,
  1930.00,
  'Sheet Total Amount: 1600'
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Fatima Rashid', null, 1600.00, true
from public.families
where family_code = 'EGSS-FAM-0035';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 1600.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0035'
  and fc.month_key = date '2023-03-01';

-- Rizwan Manzoor / 72
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0036', '72', 'Rizwan Manzoor', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0036' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  2000.00,
  0.00,
  2830.00,
  4830.00,
  2000.00,
  2830.00,
  'Sheet Total Amount: 2000'
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Abdul Hadi', null, 2000.00, true
from public.families
where family_code = 'EGSS-FAM-0036';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 2000.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0036'
  and fc.month_key = date '2023-03-01';

-- Asif Hussain / 38
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0037', '38', 'Asif Hussain', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0037' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1600.00,
  0.00,
  0.00,
  1600.00,
  0.00,
  1600.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Kainat Nazir', null, 1600.00, true
from public.families
where family_code = 'EGSS-FAM-0037';

-- Kashif Nazir / 15
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0038', '15', 'Kashif Nazir', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0038' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3500.00,
  1160.00,
  0.00,
  4660.00,
  0.00,
  4660.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Umer Kashif', null, 1750.00, true
from public.families
where family_code = 'EGSS-FAM-0038';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Bilal Kashif', null, 1750.00, true
from public.families
where family_code = 'EGSS-FAM-0038';

-- M.Zubair / 21
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0039', '21', 'M.Zubair', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0039' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1900.00,
  0.00,
  5030.00,
  6930.00,
  1900.00,
  5030.00,
  'Sheet Total Amount: 1900'
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Azan', null, 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0039';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 1900.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0039'
  and fc.month_key = date '2023-03-01';

-- Abid-ullah-Zahid / 19
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0040', '19', 'Abid-ullah-Zahid', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0040' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3600.00,
  0.00,
  0.00,
  3600.00,
  1200.00,
  2400.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Umer', null, 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0040';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Fatima-ul-Zahra', null, 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0040';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 1200.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0040'
  and fc.month_key = date '2023-03-01';

-- M.Awais / 12
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0041', '12', 'M.Awais', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0041' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3700.00,
  8680.00,
  0.00,
  12380.00,
  3500.00,
  8880.00,
  'Sheet Total Amount: 3700'
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Ahmad Hassan', null, 1850.00, true
from public.families
where family_code = 'EGSS-FAM-0041';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Rana Hussain', null, 1850.00, true
from public.families
where family_code = 'EGSS-FAM-0041';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 3500.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0041'
  and fc.month_key = date '2023-03-01';

-- Nassar Hayat / 11
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0042', '11', 'Nassar Hayat', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0042' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3900.00,
  0.00,
  0.00,
  3900.00,
  3900.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Abu Bakar', null, 1950.00, true
from public.families
where family_code = 'EGSS-FAM-0042';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Abu Harraira', null, 1950.00, true
from public.families
where family_code = 'EGSS-FAM-0042';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 3900.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0042'
  and fc.month_key = date '2023-03-01';

-- Allaha Rakha / 95
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0043', '95', 'Allaha Rakha', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0043' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3800.00,
  3300.00,
  0.00,
  7100.00,
  0.00,
  7100.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Ghulshan Shahzadi', null, 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0043';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Ali Raza', null, 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0043';

-- M.Afzal / 14
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0044', '14', 'M.Afzal', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0044' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  6300.00,
  11980.00,
  5700.00,
  23980.00,
  0.00,
  23980.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Avarish', null, 2100.00, true
from public.families
where family_code = 'EGSS-FAM-0044';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Zernish', null, 2100.00, true
from public.families
where family_code = 'EGSS-FAM-0044';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Rehan', null, 2100.00, true
from public.families
where family_code = 'EGSS-FAM-0044';

-- Ghulam Ali / 67
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0045', '67', 'Ghulam Ali', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0045' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  4800.00,
  17600.00,
  9780.00,
  32180.00,
  32180.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Saira Ali', null, 2400.00, true
from public.families
where family_code = 'EGSS-FAM-0045';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Umer', null, 2400.00, true
from public.families
where family_code = 'EGSS-FAM-0045';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 32180.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0045'
  and fc.month_key = date '2023-03-01';

-- Imran Ashraf / 10
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0046', '10', 'Imran Ashraf', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0046' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  6600.00,
  0.00,
  0.00,
  6600.00,
  0.00,
  6600.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Abdul Rehman', null, 1650.00, true
from public.families
where family_code = 'EGSS-FAM-0046';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Abdullah', null, 1650.00, true
from public.families
where family_code = 'EGSS-FAM-0046';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Umer', null, 1650.00, true
from public.families
where family_code = 'EGSS-FAM-0046';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Rameen', null, 1650.00, true
from public.families
where family_code = 'EGSS-FAM-0046';

-- M. Mstaqeem Khan / 61
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0047', '61', 'M. Mstaqeem Khan', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0047' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1900.00,
  0.00,
  0.00,
  1900.00,
  1900.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Qasim', '1st', 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0047';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 1900.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0047'
  and fc.month_key = date '2023-03-01';

-- Iran Khan / 41
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0048', '41', 'Iran Khan', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0048' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3600.00,
  0.00,
  6000.00,
  9600.00,
  3600.00,
  6000.00,
  'Sheet Total Amount: 3600'
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Aima Iran', '1st', 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0048';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Hussain Khan', '3rd', 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0048';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 3600.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0048'
  and fc.month_key = date '2023-03-01';

-- Amir Shahzad / 78
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0049', '78', 'Amir Shahzad', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0049' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  6300.00,
  0.00,
  2600.00,
  8900.00,
  6300.00,
  2600.00,
  'Sheet Total Amount: 6300'
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Ibrahim', '4th', 2100.00, true
from public.families
where family_code = 'EGSS-FAM-0049';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Zain ul abdin', '5th', 2100.00, true
from public.families
where family_code = 'EGSS-FAM-0049';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Saira Parveen', '8th', 2100.00, true
from public.families
where family_code = 'EGSS-FAM-0049';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 6300.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0049'
  and fc.month_key = date '2023-03-01';

-- Abid Hussain / 76
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0050', '76', 'Abid Hussain', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0050' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1900.00,
  0.00,
  0.00,
  1900.00,
  1900.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Fatima Tuz Zahra', '2nd', 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0050';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 1900.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0050'
  and fc.month_key = date '2023-03-01';

-- M Asif / 6
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0051', '6', 'M Asif', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0051' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3500.00,
  9860.00,
  0.00,
  13360.00,
  0.00,
  13360.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Abul Hadi', 'Prep', 1750.00, true
from public.families
where family_code = 'EGSS-FAM-0051';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Bilal Asif', '3rd', 1750.00, true
from public.families
where family_code = 'EGSS-FAM-0051';

-- Arshad Aslam / 79
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0052', '79', 'Arshad Aslam', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0052' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3600.00,
  3600.00,
  0.00,
  7200.00,
  0.00,
  7200.00,
  'Sheet Total Amount: 3600'
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Arish Aslam', '4th', 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0052';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M. Arham Abbas', '6th', 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0052';

-- Iran Khan / 71
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0053', '71', 'Iran Khan', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0053' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1800.00,
  0.00,
  0.00,
  1800.00,
  1800.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Aira Irfan', 'Nursery', 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0053';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 1800.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0053'
  and fc.month_key = date '2023-03-01';

-- M. Imran / 31
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0054', '31', 'M. Imran', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0054' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3300.00,
  8370.00,
  0.00,
  11670.00,
  0.00,
  11670.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Anaya Fatima', 'Prep', 1650.00, true
from public.families
where family_code = 'EGSS-FAM-0054';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Areeba Imran', '3rd', 1650.00, true
from public.families
where family_code = 'EGSS-FAM-0054';

-- Majad Hussain / 41
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0055', '41', 'Majad Hussain', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0055' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  7800.00,
  3870.00,
  0.00,
  11670.00,
  0.00,
  11670.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Azan Ali', 'PreP', 1950.00, true
from public.families
where family_code = 'EGSS-FAM-0055';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Hiba Fatima', 'Pre', 1950.00, true
from public.families
where family_code = 'EGSS-FAM-0055';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Shahzad Ali', '4th', 1950.00, true
from public.families
where family_code = 'EGSS-FAM-0055';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'zahira Fatima', '3rd', 1950.00, true
from public.families
where family_code = 'EGSS-FAM-0055';

-- M.Yaseen / 51
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0056', '51', 'M.Yaseen', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0056' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3300.00,
  10000.00,
  0.00,
  13300.00,
  0.00,
  13300.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Abdul Manan', 'Prep', 1650.00, true
from public.families
where family_code = 'EGSS-FAM-0056';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Urooj Fatima', 'Prep', 1650.00, true
from public.families
where family_code = 'EGSS-FAM-0056';

-- Abid Ali / 86
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0057', '86', 'Abid Ali', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0057' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1500.00,
  0.00,
  0.00,
  1500.00,
  1500.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Fatima Abid', '5th', 1500.00, true
from public.families
where family_code = 'EGSS-FAM-0057';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 1500.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0057'
  and fc.month_key = date '2023-03-01';

-- Ghulam Mujaba / 87
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0058', '87', 'Ghulam Mujaba', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0058' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  2000.00,
  0.00,
  0.00,
  2000.00,
  2000.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Hussain', '6th', 2000.00, true
from public.families
where family_code = 'EGSS-FAM-0058';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 2000.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0058'
  and fc.month_key = date '2023-03-01';

-- Fazal Hussain / 84
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0059', '84', 'Fazal Hussain', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0059' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  2000.00,
  0.00,
  0.00,
  2000.00,
  2000.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Obaid', '7th', 2000.00, true
from public.families
where family_code = 'EGSS-FAM-0059';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 2000.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0059'
  and fc.month_key = date '2023-03-01';

-- M.Shoaib Asghar / 64
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0060', '64', 'M.Shoaib Asghar', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0060' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  2200.00,
  48220.00,
  0.00,
  50420.00,
  0.00,
  50420.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Zain Asghar', 'Pre 9th', 2200.00, true
from public.families
where family_code = 'EGSS-FAM-0060';

-- Shahid Ali / 54
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0061', '54', 'Shahid Ali', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0061' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  2000.00,
  2500.00,
  0.00,
  4500.00,
  0.00,
  4500.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M. Awais', '4th', 2000.00, true
from public.families
where family_code = 'EGSS-FAM-0061';

-- Ghulam Mustafa / 30
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0062', '30', 'Ghulam Mustafa', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0062' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3800.00,
  2690.00,
  0.00,
  6490.00,
  0.00,
  6490.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M Umar(2nd) Sajal', '4th', 3800.00, true
from public.families
where family_code = 'EGSS-FAM-0062';

-- Abu Safian / 56
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0063', '56', 'Abu Safian', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0063' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  5600.00,
  0.00,
  0.00,
  5600.00,
  5300.00,
  300.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Sheza Safian(1st)Ali Hassan(2nd) Hassan', '7th', 5600.00, true
from public.families
where family_code = 'EGSS-FAM-0063';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 5300.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0063'
  and fc.month_key = date '2023-03-01';

-- Lal Khan / 57
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0064', '57', 'Lal Khan', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0064' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1800.00,
  0.00,
  0.00,
  1800.00,
  1600.00,
  200.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Faizan Merani', '1st', 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0064';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 1600.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0064'
  and fc.month_key = date '2023-03-01';

-- M Afzal / 89
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0065', '89', 'M Afzal', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0065' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3000.00,
  6900.00,
  0.00,
  9900.00,
  0.00,
  9900.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Frza Fatima', '5th', 1500.00, true
from public.families
where family_code = 'EGSS-FAM-0065';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Rehan Afzaal', '6th', 1500.00, true
from public.families
where family_code = 'EGSS-FAM-0065';

-- Tariq Mehmood / 44
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0066', '44', 'Tariq Mehmood', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0066' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  5700.00,
  14250.00,
  0.00,
  19950.00,
  0.00,
  19950.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M Harib Tariq', '1st', 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0066';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M Iraj Tariq', '5th', 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0066';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Moueez Tariq', '3rd', 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0066';

-- Anwar Hussain Shah,Hussain / 58
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0067', '58', 'Anwar Hussain Shah,Hussain', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0067' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  5600.00,
  0.00,
  0.00,
  5600.00,
  5000.00,
  600.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Syed Nalain', '1st', 1866.66, true
from public.families
where family_code = 'EGSS-FAM-0067';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Anam Fatima', '3rd', 1866.66, true
from public.families
where family_code = 'EGSS-FAM-0067';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Zahra fatima', 'Prep', 1866.68, true
from public.families
where family_code = 'EGSS-FAM-0067';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 5000.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0067'
  and fc.month_key = date '2023-03-01';

-- Abdul Rauf / 33
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0068', '33', 'Abdul Rauf', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0068' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  5100.00,
  9000.00,
  0.00,
  14100.00,
  0.00,
  14100.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M. Kabeer Ali', 'Prep', 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0068';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Horain Fatima', 'Prep', 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0068';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M Hussnain', '3rd', 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0068';

-- M Saleem / 32
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0069', '32', 'M Saleem', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0069' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3800.00,
  4160.00,
  0.00,
  7960.00,
  0.00,
  7960.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M Burhan', 'Prep', 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0069';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Reyyan Saleem', '5th', 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0069';

-- Mushtaq Ahmad / 87
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0070', '87', 'Mushtaq Ahmad', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0070' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  0.00,
  0.00,
  3050.00,
  3050.00,
  0.00,
  3050.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Amber Mushtaq', '5th', 0.00, true
from public.families
where family_code = 'EGSS-FAM-0070';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Subhan Ali', '8th', 0.00, true
from public.families
where family_code = 'EGSS-FAM-0070';

-- M Bilal / 59
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0071', '59', 'M Bilal', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0071' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  5500.00,
  0.00,
  14250.00,
  19750.00,
  5500.00,
  14250.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Abdul Subhan', '1st', 1833.33, true
from public.families
where family_code = 'EGSS-FAM-0071';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Maham Fatima', '3rd', 1833.33, true
from public.families
where family_code = 'EGSS-FAM-0071';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Eman Fatima', '6th', 1833.34, true
from public.families
where family_code = 'EGSS-FAM-0071';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 5500.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0071'
  and fc.month_key = date '2023-03-01';

-- M Sarwar / 60
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0072', '60', 'M Sarwar', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0072' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  2000.00,
  0.00,
  0.00,
  2000.00,
  0.00,
  2000.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Iqra Sarwar', '1st', 2000.00, true
from public.families
where family_code = 'EGSS-FAM-0072';

-- Faiz Ahmad / 74
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0073', '74', 'Faiz Ahmad', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0073' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3900.00,
  0.00,
  660.00,
  4560.00,
  3900.00,
  660.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Anam Fatima', '2nd', 1950.00, true
from public.families
where family_code = 'EGSS-FAM-0073';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Rehan Ahmed', 'Nursery', 1950.00, true
from public.families
where family_code = 'EGSS-FAM-0073';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 3900.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0073'
  and fc.month_key = date '2023-03-01';

-- Arshad / 36
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0074', '36', 'Arshad', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0074' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1800.00,
  0.00,
  0.00,
  1800.00,
  1800.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M. Arham', 'Nursery', 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0074';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 1800.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0074'
  and fc.month_key = date '2023-03-01';

-- Ashfaq Ahmad / 49
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0075', '49', 'Ashfaq Ahmad', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0075' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  4000.00,
  0.00,
  0.00,
  4000.00,
  0.00,
  4000.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M Ali', '1st', 2000.00, true
from public.families
where family_code = 'EGSS-FAM-0075';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Minahal', '3rd', 2000.00, true
from public.families
where family_code = 'EGSS-FAM-0075';

-- Ali Asghar / 73
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0076', '73', 'Ali Asghar', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0076' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3700.00,
  0.00,
  0.00,
  3700.00,
  0.00,
  3700.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Jannat Batool', '2nd', 1850.00, true
from public.families
where family_code = 'EGSS-FAM-0076';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Umee-Farwa', '3rd', 1850.00, true
from public.families
where family_code = 'EGSS-FAM-0076';

-- Sajjad Ali,Shabbaz Faisal / 63
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0077', '63', 'Sajjad Ali,Shabbaz Faisal', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0077' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  4800.00,
  0.00,
  4530.00,
  9330.00,
  4800.00,
  4530.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Ali Abbas', '2nd', 1600.00, true
from public.families
where family_code = 'EGSS-FAM-0077';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Zania', '2nd', 1600.00, true
from public.families
where family_code = 'EGSS-FAM-0077';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Khadija', 'Prep', 1600.00, true
from public.families
where family_code = 'EGSS-FAM-0077';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 4800.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0077'
  and fc.month_key = date '2023-03-01';

-- Sahail khuram Shahzad / 66
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0078', '66', 'Sahail khuram Shahzad', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0078' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3500.00,
  0.00,
  0.00,
  3500.00,
  3500.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Abdullah Sultan', 'Prep', 1750.00, true
from public.families
where family_code = 'EGSS-FAM-0078';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Aiza Fatima', '2nd', 1750.00, true
from public.families
where family_code = 'EGSS-FAM-0078';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 3500.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0078'
  and fc.month_key = date '2023-03-01';

-- Tanveer Iqbal / 93
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0079', '93', 'Tanveer Iqbal', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0079' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  6100.00,
  0.00,
  0.00,
  6100.00,
  6100.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Zainab Tanveer', '5th', 2033.33, true
from public.families
where family_code = 'EGSS-FAM-0079';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Fatima Tanveer', '5th', 2033.33, true
from public.families
where family_code = 'EGSS-FAM-0079';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Haleema', 'Nursery', 2033.34, true
from public.families
where family_code = 'EGSS-FAM-0079';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 6100.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0079'
  and fc.month_key = date '2023-03-01';

-- M Qasim / 42
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0080', '42', 'M Qasim', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0080' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  5600.00,
  3860.00,
  0.00,
  9460.00,
  0.00,
  9460.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M Muzaifa', '1st', 1866.66, true
from public.families
where family_code = 'EGSS-FAM-0080';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Umaima', '3rd', 1866.66, true
from public.families
where family_code = 'EGSS-FAM-0080';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Mirha', 'Nursery', 1866.68, true
from public.families
where family_code = 'EGSS-FAM-0080';

-- Waseem Abbas / 65
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0081', '65', 'Waseem Abbas', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0081' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  5500.00,
  14610.00,
  4650.00,
  24760.00,
  0.00,
  24760.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Hareem Fatima', '2nd', 1833.33, true
from public.families
where family_code = 'EGSS-FAM-0081';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Hazaq', '4th', 1833.33, true
from public.families
where family_code = 'EGSS-FAM-0081';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Ayyan Ali', '6th', 1833.34, true
from public.families
where family_code = 'EGSS-FAM-0081';

-- Allah Ditta / 91
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0082', '91', 'Allah Ditta', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0082' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1800.00,
  0.00,
  0.00,
  1800.00,
  1800.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M Talah', '5th', 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0082';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 1800.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0082'
  and fc.month_key = date '2023-03-01';

-- Amjad Ali / 70
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0083', '70', 'Amjad Ali', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0083' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  13000.00,
  13570.00,
  13570.00,
  40140.00,
  26570.00,
  13570.00,
  'Imported Month of Fee: March+ Feb'
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M Talal(2nd)M Adan(3rd)Abdul Hadi', '7th', 6500.00, true
from public.families
where family_code = 'EGSS-FAM-0083';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Ayan Amjad', '9th', 6500.00, true
from public.families
where family_code = 'EGSS-FAM-0083';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 26570.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0083'
  and fc.month_key = date '2023-03-01';

-- M Afzal / 92
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0084', '92', 'M Afzal', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0084' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3600.00,
  6000.00,
  0.00,
  9600.00,
  3600.00,
  6000.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Adil Afzal', '5th', 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0084';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Hania', 'Prep', 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0084';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 3600.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0084'
  and fc.month_key = date '2023-03-01';

-- Akram Ullah / 96
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0085', '96', 'Akram Ullah', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0085' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  4200.00,
  0.00,
  0.00,
  4200.00,
  4000.00,
  200.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Qasim Akram', '5th', 2100.00, true
from public.families
where family_code = 'EGSS-FAM-0085';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Subhan Akram', '10th', 2100.00, true
from public.families
where family_code = 'EGSS-FAM-0085';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 4000.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0085'
  and fc.month_key = date '2023-03-01';

-- Rana Shakeel Ahmed / 31
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0086', '31', 'Rana Shakeel Ahmed', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0086' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  4000.00,
  0.00,
  0.00,
  4000.00,
  0.00,
  4000.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M Faizan', 'Nursery', 1333.33, true
from public.families
where family_code = 'EGSS-FAM-0086';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Adiqa', '1st', 1333.33, true
from public.families
where family_code = 'EGSS-FAM-0086';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Anaya', '3rd', 1333.34, true
from public.families
where family_code = 'EGSS-FAM-0086';

-- M Imran / 37
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0087', '37', 'M Imran', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0087' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3400.00,
  28900.00,
  0.00,
  32300.00,
  0.00,
  32300.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Dua Fatima', '1st', 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0087';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Maida Noor', '6th', 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0087';

-- Imran Ashraf / 10
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0088', '10', 'Imran Ashraf', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0088' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  6600.00,
  0.00,
  0.00,
  6600.00,
  6600.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Abdul-Rehman', 'Nursery', 1650.00, true
from public.families
where family_code = 'EGSS-FAM-0088';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Abdullah', '3rd', 1650.00, true
from public.families
where family_code = 'EGSS-FAM-0088';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Rameen', '7th', 1650.00, true
from public.families
where family_code = 'EGSS-FAM-0088';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M Umer', '4th', 1650.00, true
from public.families
where family_code = 'EGSS-FAM-0088';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 6600.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0088'
  and fc.month_key = date '2023-03-01';

-- M Shahbaz / 17
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0089', '17', 'M Shahbaz', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0089' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  10000.00,
  10000.00,
  19060.00,
  39060.00,
  39060.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Fajar', 'Prep', 2000.00, true
from public.families
where family_code = 'EGSS-FAM-0089';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Meheram', 'Prep', 2000.00, true
from public.families
where family_code = 'EGSS-FAM-0089';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Mahnoor', '5th', 2000.00, true
from public.families
where family_code = 'EGSS-FAM-0089';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Hassan', '6th', 2000.00, true
from public.families
where family_code = 'EGSS-FAM-0089';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Hareeb Ali', '6th', 2000.00, true
from public.families
where family_code = 'EGSS-FAM-0089';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 39060.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0089'
  and fc.month_key = date '2023-03-01';

-- Zahid Riaz / 99
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0090', '99', 'Zahid Riaz', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0090' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  2000.00,
  0.00,
  0.00,
  2000.00,
  2000.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Abiha Zahid', '7th', 2000.00, true
from public.families
where family_code = 'EGSS-FAM-0090';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 2000.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0090'
  and fc.month_key = date '2023-03-01';

-- M Nasir / 98
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0091', '98', 'M Nasir', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0091' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3600.00,
  3000.00,
  0.00,
  6600.00,
  0.00,
  6600.00,
  'Imported Month of Fee: March/Feb'
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Azan Nasir', '7th', 3600.00, true
from public.families
where family_code = 'EGSS-FAM-0091';

-- M Alayas / 100
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0092', '100', 'M Alayas', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0092' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1700.00,
  0.00,
  0.00,
  1700.00,
  1700.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Zaman Alayas', '7th', 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0092';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 1700.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0092'
  and fc.month_key = date '2023-03-01';

-- Ghulam Murtaza / 97
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0093', '97', 'Ghulam Murtaza', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0093' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  4300.00,
  0.00,
  0.00,
  4300.00,
  0.00,
  4300.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Samavia Murtaza', '6th', 2150.00, true
from public.families
where family_code = 'EGSS-FAM-0093';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Azan Murtaza', '8th', 2150.00, true
from public.families
where family_code = 'EGSS-FAM-0093';

-- Allah Ditta / 1
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0094', '1', 'Allah Ditta', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0094' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  2900.00,
  7130.00,
  2900.00,
  12930.00,
  5000.00,
  7930.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Anaya sadiqa', null, 966.66, true
from public.families
where family_code = 'EGSS-FAM-0094';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Ayesha Nur', null, 966.66, true
from public.families
where family_code = 'EGSS-FAM-0094';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Prep', null, 966.68, true
from public.families
where family_code = 'EGSS-FAM-0094';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 5000.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0094'
  and fc.month_key = date '2023-03-01';

-- M.Riaz / 11
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0095', '11', 'M.Riaz', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0095' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1500.00,
  0.00,
  0.00,
  1500.00,
  1500.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Maryam 7th', null, 1500.00, true
from public.families
where family_code = 'EGSS-FAM-0095';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 1500.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0095'
  and fc.month_key = date '2023-03-01';

-- Qaiser Mehmood / 36
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0096', '36', 'Qaiser Mehmood', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0096' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3100.00,
  0.00,
  0.00,
  3100.00,
  2700.00,
  400.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Um.e.Hania', null, 1033.33, true
from public.families
where family_code = 'EGSS-FAM-0096';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Esha Qaisar 1st', null, 1033.33, true
from public.families
where family_code = 'EGSS-FAM-0096';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, '3rd', null, 1033.34, true
from public.families
where family_code = 'EGSS-FAM-0096';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 2700.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0096'
  and fc.month_key = date '2023-03-01';

-- Yasir / 6
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0097', '6', 'Yasir', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0097' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1700.00,
  0.00,
  0.00,
  1700.00,
  1700.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Arash Noor P.G', null, 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0097';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 1700.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0097'
  and fc.month_key = date '2023-03-01';

-- M.Bilal / 8
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0098', '8', 'M.Bilal', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0098' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1500.00,
  3950.00,
  0.00,
  5450.00,
  0.00,
  5450.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Haris 5th', null, 1500.00, true
from public.families
where family_code = 'EGSS-FAM-0098';

-- M.Imran / 21
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0099', '21', 'M.Imran', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0099' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1900.00,
  0.00,
  0.00,
  1900.00,
  1900.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Murtaa Imran Nur', null, 1900.00, true
from public.families
where family_code = 'EGSS-FAM-0099';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 1900.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0099'
  and fc.month_key = date '2023-03-01';

-- M.Ashraf / 19
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0100', '19', 'M.Ashraf', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0100' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3900.00,
  0.00,
  0.00,
  3900.00,
  3200.00,
  700.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Ali Shair 8th', null, 1950.00, true
from public.families
where family_code = 'EGSS-FAM-0100';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Ali Hassan Prep', null, 1950.00, true
from public.families
where family_code = 'EGSS-FAM-0100';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 3200.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0100'
  and fc.month_key = date '2023-03-01';

-- Zahid Mansoor / 25
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0101', '25', 'Zahid Mansoor', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0101' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  2000.00,
  3460.00,
  0.00,
  5460.00,
  1800.00,
  3660.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Ahsan Zahid 3rd', null, 2000.00, true
from public.families
where family_code = 'EGSS-FAM-0101';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 1800.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0101'
  and fc.month_key = date '2023-03-01';

-- Kashif Ali / 30
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0102', '30', 'Kashif Ali', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0102' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3200.00,
  0.00,
  3830.00,
  7030.00,
  3200.00,
  3830.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Ali Hassan 3rd', null, 1600.00, true
from public.families
where family_code = 'EGSS-FAM-0102';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Sohaib Haider 6th', null, 1600.00, true
from public.families
where family_code = 'EGSS-FAM-0102';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 3200.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0102'
  and fc.month_key = date '2023-03-01';

-- M.Mushataq / 37
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0103', '37', 'M.Mushataq', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0103' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  4000.00,
  0.00,
  0.00,
  4000.00,
  0.00,
  4000.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Faria Mushtaq Prep', null, 2000.00, true
from public.families
where family_code = 'EGSS-FAM-0103';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Mustafa 1st', null, 2000.00, true
from public.families
where family_code = 'EGSS-FAM-0103';

-- Zaheer Abbas / 24
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0104', '24', 'Zaheer Abbas', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0104' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  6000.00,
  5000.00,
  0.00,
  11000.00,
  0.00,
  11000.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Ahmad Nur', null, 1500.00, true
from public.families
where family_code = 'EGSS-FAM-0104';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Momina 2nd', null, 1500.00, true
from public.families
where family_code = 'EGSS-FAM-0104';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Maria 3rd', null, 1500.00, true
from public.families
where family_code = 'EGSS-FAM-0104';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Fahad 2nd', null, 1500.00, true
from public.families
where family_code = 'EGSS-FAM-0104';

-- Shahid Ali / 10
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0105', '10', 'Shahid Ali', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0105' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  5100.00,
  0.00,
  5330.00,
  10430.00,
  5100.00,
  5330.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Zoya ShahZadi Nur', null, 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0105';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Azlan 1st', null, 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0105';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Ali Hassan 2nd', null, 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0105';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 5100.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0105'
  and fc.month_key = date '2023-03-01';

-- Nabeel Khalid / 14
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0106', '14', 'Nabeel Khalid', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0106' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1800.00,
  3330.00,
  0.00,
  5130.00,
  0.00,
  5130.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Arham Nur', null, 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0106';

-- AfZaal Hussain / 13
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0107', '13', 'AfZaal Hussain', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0107' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1800.00,
  0.00,
  0.00,
  1800.00,
  1800.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Saim Ali 7th', null, 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0107';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 1800.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0107'
  and fc.month_key = date '2023-03-01';

-- Hassan Hussain / 23
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0108', '23', 'Hassan Hussain', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0108' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3400.00,
  0.00,
  200.00,
  3600.00,
  3400.00,
  200.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'FaiZan 1st', null, 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0108';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Subhan Ali 6th', null, 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0108';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 3400.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0108'
  and fc.month_key = date '2023-03-01';

-- M.Akram / 15
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0109', '15', 'M.Akram', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0109' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  2200.00,
  0.00,
  2830.00,
  5030.00,
  2200.00,
  2830.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Hussain Akram PG Nur', null, 2200.00, true
from public.families
where family_code = 'EGSS-FAM-0109';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 2200.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0109'
  and fc.month_key = date '2023-03-01';

-- M.Zohaib Aam / 28
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0110', '28', 'M.Zohaib Aam', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0110' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  2100.00,
  0.00,
  0.00,
  2100.00,
  2100.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Ibrahim 3rd', null, 2100.00, true
from public.families
where family_code = 'EGSS-FAM-0110';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 2100.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0110'
  and fc.month_key = date '2023-03-01';

-- Abdul-Lateef / 20
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0111', '20', 'Abdul-Lateef', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0111' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1500.00,
  0.00,
  0.00,
  1500.00,
  1500.00,
  0.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Sufian 2nd', null, 1500.00, true
from public.families
where family_code = 'EGSS-FAM-0111';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 1500.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0111'
  and fc.month_key = date '2023-03-01';

-- Ghulam Mustafa / 40
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0112', '40', 'Ghulam Mustafa', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0112' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  3400.00,
  0.00,
  7010.00,
  10410.00,
  3400.00,
  7010.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Smaya Ghulam Prep', null, 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0112';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Minahil Mustafa Nur', null, 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0112';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 3400.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0112'
  and fc.month_key = date '2023-03-01';

-- Shahid Mehmood / 12
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0113', '12', 'Shahid Mehmood', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0113' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  2500.00,
  0.00,
  3140.00,
  5640.00,
  2500.00,
  3140.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Momna 9th', null, 2500.00, true
from public.families
where family_code = 'EGSS-FAM-0113';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 2500.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0113'
  and fc.month_key = date '2023-03-01';

-- Sajid Ali / 27
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0114', '27', 'Sajid Ali', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0114' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1800.00,
  100.00,
  0.00,
  1900.00,
  1600.00,
  300.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Hijab Zara 3rd', null, 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0114';
insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, 1600.00, date '2023-03-10', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = 'EGSS-FAM-0114'
  and fc.month_key = date '2023-03-01';

-- M. Sajjad / 16
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0115', '16', 'M. Sajjad', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0115' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  2500.00,
  0.00,
  0.00,
  2500.00,
  0.00,
  2500.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'M.Talha prep', null, 1250.00, true
from public.families
where family_code = 'EGSS-FAM-0115';
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Horia P.G', null, 1250.00, true
from public.families
where family_code = 'EGSS-FAM-0115';

-- M.Abbas / 31
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0116', '31', 'M.Abbas', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0116' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1800.00,
  0.00,
  0.00,
  1800.00,
  0.00,
  1800.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Ahmed Abbas 4th', null, 1800.00, true
from public.families
where family_code = 'EGSS-FAM-0116';

-- Rashid Ali / 41
with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('EGSS-FAM-0117', '41', 'Rashid Ali', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = 'EGSS-FAM-0117' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '2023-03-01'
)
insert into public.monthly_fee_records (
  family_id,
  fee_cycle_id,
  tuition_amount,
  other_charges,
  carry_forward_amount,
  total_due,
  amount_received,
  arrears_amount,
  note
)
select
  selected_family.id,
  selected_cycle.id,
  1700.00,
  2430.00,
  0.00,
  4130.00,
  0.00,
  4130.00,
  null
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;
insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, 'Sadia Rashid prep', null, 1700.00, true
from public.families
where family_code = 'EGSS-FAM-0117';

commit;

