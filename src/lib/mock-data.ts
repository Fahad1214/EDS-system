import importedData from "@/lib/imported-fees.json";
import type { DashboardFamilyRecord, SummaryCard } from "@/types/fees";

export const schoolName = importedData.schoolName;
export const activeMonthLabel = importedData.billingCycle.label;
export const familyRecords: DashboardFamilyRecord[] = importedData.dashboardRecords.map(
  (record, index) => ({
    id: record.id ?? `mock-${index + 1}`,
    familyId: `mock-family-${index + 1}`,
    feeCycleId: importedData.billingCycle.monthKey,
    familyNumber: record.familyNumber,
    familyCode: record.familyCode,
    students: record.students,
    classNames: [],
    fatherName: record.fatherName,
    phone: record.phone,
    monthLabel: record.monthLabel,
    monthKey: importedData.billingCycle.monthKey,
    tuitionFee: record.tuitionFee,
    otherCharges: record.otherCharges,
    annualFund: 0,
    carriedForward: record.carriedForward,
    amountReceived: record.amountReceived,
    dueDate: record.dueDate,
    note: record.importNote ?? "",
  }),
);

export function getTotalDue(record: DashboardFamilyRecord) {
  return record.tuitionFee + record.otherCharges + record.carriedForward;
}

export function getArrears(record: DashboardFamilyRecord) {
  return Math.max(getTotalDue(record) - record.amountReceived, 0);
}

export function getStatus(record: DashboardFamilyRecord) {
  const arrears = getArrears(record);

  if (arrears === 0) {
    return "paid" as const;
  }

  if (record.amountReceived > 0) {
    return "partial" as const;
  }

  return "pending" as const;
}

export const summaryCards: SummaryCard[] = [
  {
    label: "Families This Month",
    value: `${familyRecords.length}`,
    helper: "Current monthly fee records loaded for the active cycle.",
  },
  {
    label: "Total Due",
    value: `Rs. ${familyRecords
      .reduce((sum, record) => sum + getTotalDue(record), 0)
      .toLocaleString()}`,
    helper: "Tuition, other charges, and carried-forward arrears combined.",
  },
  {
    label: "Collected",
    value: `Rs. ${familyRecords
      .reduce((sum, record) => sum + record.amountReceived, 0)
      .toLocaleString()}`,
    helper: "Payments received so far for the active month.",
  },
  {
    label: "Still Pending",
    value: `Rs. ${familyRecords
      .reduce((sum, record) => sum + getArrears(record), 0)
      .toLocaleString()}`,
    helper: "This amount can be pushed automatically into the next month.",
  },
];
