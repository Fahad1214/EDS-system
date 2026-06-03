import type { DashboardFamilyRecord } from "@/types/fees";

export type FeeAmountFields = Pick<
  DashboardFamilyRecord,
  "tuitionFee" | "otherCharges" | "carriedForward" | "annualFund"
>;

export type FeeBalanceFields = FeeAmountFields &
  Pick<DashboardFamilyRecord, "amountReceived">;

export function getTotalDue(record: FeeAmountFields) {
  return record.tuitionFee + record.otherCharges + record.carriedForward + record.annualFund;
}

export function getArrears(record: FeeBalanceFields) {
  return Math.max(getTotalDue(record) - record.amountReceived, 0);
}

export function getPaymentStatus(record: FeeBalanceFields) {
  const arrears = getArrears(record);

  if (arrears === 0) {
    return "paid" as const;
  }

  if (record.amountReceived > 0) {
    return "partial" as const;
  }

  return "pending" as const;
}
