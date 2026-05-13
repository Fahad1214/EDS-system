export type PaymentStatus = "paid" | "partial" | "pending";

export type DashboardFamilyRecord = {
  id: string;
  familyId: string;
  feeCycleId: string;
  familyNumber: string;
  familyCode: string;
  students: string[];
  classNames: string[];
  fatherName: string;
  phone: string;
  monthLabel: string;
  monthKey: string;
  tuitionFee: number;
  otherCharges: number;
  carriedForward: number;
  amountReceived: number;
  dueDate: string;
  note?: string;
};

export type SummaryCard = {
  label: string;
  value: string;
  helper: string;
};

export type PrintableSlip = {
  schoolName: string;
  receiptId: string;
  operator: string;
  monthLabel: string;
  familyNumber: string;
  students: string[];
  studentLabel: string;
  fatherName: string;
  phone: string;
  issueDate: string;
  paymentDate: string;
  dueDate: string;
  classLabel: string;
  sectionLabel: string;
  rollNumber: string;
  tuitionFee: number;
  otherCharges: number;
  carriedForward: number;
  totalDue: number;
  amountReceived: number;
  arrears: number;
};
