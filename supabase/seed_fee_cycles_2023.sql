-- Creates all 12 months for 2023 and monthly records for every active family.
-- Safe to re-run: existing family/month rows are skipped.

select public.create_next_fee_cycle(date '2023-01-01', 'January 2023', date '2023-01-10');
select public.create_next_fee_cycle(date '2023-02-01', 'February 2023', date '2023-02-10');
select public.create_next_fee_cycle(date '2023-03-01', 'March 2023', date '2023-03-10');
select public.create_next_fee_cycle(date '2023-04-01', 'April 2023', date '2023-04-10');
select public.create_next_fee_cycle(date '2023-05-01', 'May 2023', date '2023-05-10');
select public.create_next_fee_cycle(date '2023-06-01', 'June 2023', date '2023-06-10');
select public.create_next_fee_cycle(date '2023-07-01', 'July 2023', date '2023-07-10');
select public.create_next_fee_cycle(date '2023-08-01', 'August 2023', date '2023-08-10');
select public.create_next_fee_cycle(date '2023-09-01', 'September 2023', date '2023-09-10');
select public.create_next_fee_cycle(date '2023-10-01', 'October 2023', date '2023-10-10');
select public.create_next_fee_cycle(date '2023-11-01', 'November 2023', date '2023-11-10');
select public.create_next_fee_cycle(date '2023-12-01', 'December 2023', date '2023-12-10');

-- Ensure carry-forward uses the previous calendar month, not creation order.
select public.recalculate_carry_forward(2023);
