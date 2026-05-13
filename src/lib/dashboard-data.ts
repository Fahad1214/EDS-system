import importedData from "@/lib/imported-fees.json";
import { getSupabaseServerClient } from "@/lib/supabase/server";
import type { DashboardFamilyRecord } from "@/types/fees";

type MonthlyFeeRow = {
  id: string;
  family_id: string;
  fee_cycle_id: string;
  tuition_amount: number | null;
  other_charges: number | null;
  carry_forward_amount: number | null;
  amount_received: number | null;
  note: string | null;
  families:
    | {
        id: string;
        family_code: string | null;
        legacy_family_number: string | null;
        guardian_name: string | null;
        phone: string | null;
      }
    | {
        id: string;
        family_code: string | null;
        legacy_family_number: string | null;
        guardian_name: string | null;
        phone: string | null;
      }[]
    | null;
  fee_cycles:
    | {
        id: string;
        label: string | null;
        month_key: string | null;
        due_date: string | null;
      }
    | {
        id: string;
        label: string | null;
        month_key: string | null;
        due_date: string | null;
      }[]
    | null;
};

type StudentRow = {
  id: string;
  family_id: string;
  student_name: string | null;
  class_name: string | null;
  monthly_fee: number | null;
  is_active: boolean | null;
};

type DashboardDataResult = {
  records: DashboardFamilyRecord[];
  source: "supabase" | "fallback";
};

function normalizeNumber(value: number | null | undefined) {
  return typeof value === "number" && Number.isFinite(value) ? value : 0;
}

function mapFallbackRecords(): DashboardFamilyRecord[] {
  return importedData.dashboardRecords.map((record, index) => ({
    id: record.id ?? `fallback-${index + 1}`,
    familyId: `fallback-family-${index + 1}`,
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
    carriedForward: record.carriedForward,
    amountReceived: record.amountReceived,
    dueDate: record.dueDate,
    note: record.importNote ?? "",
  }));
}

function compareMonthKeys(left: string, right: string) {
  return new Date(right).getTime() - new Date(left).getTime();
}

function getEmbeddedRow<T>(value: T | T[] | null) {
  if (Array.isArray(value)) {
    return value[0] ?? null;
  }

  return value;
}

export async function getDashboardData(): Promise<DashboardDataResult> {
  try {
    const supabase = getSupabaseServerClient();

    const [monthlyResponse, studentsResponse] = await Promise.all([
      supabase.from("monthly_fee_records").select(`
          id,
          family_id,
          fee_cycle_id,
          tuition_amount,
          other_charges,
          carry_forward_amount,
          amount_received,
          note,
          families (
            id,
            family_code,
            legacy_family_number,
            guardian_name,
            phone
          ),
          fee_cycles (
            id,
            label,
            month_key,
            due_date
          )
        `),
      supabase
        .from("students")
        .select("id, family_id, student_name, class_name, monthly_fee, is_active")
        .eq("is_active", true),
    ]);

    if (monthlyResponse.error) {
      throw monthlyResponse.error;
    }

    if (studentsResponse.error) {
      throw studentsResponse.error;
    }

    const studentMap = new Map<string, StudentRow[]>();

    for (const student of (studentsResponse.data ?? []) as StudentRow[]) {
      const existing = studentMap.get(student.family_id) ?? [];
      existing.push(student);
      studentMap.set(student.family_id, existing);
    }

    const records = ((monthlyResponse.data ?? []) as unknown as MonthlyFeeRow[])
      .map((row) => {
        const familyStudents = studentMap.get(row.family_id) ?? [];
        const family = getEmbeddedRow(row.families);
        const feeCycle = getEmbeddedRow(row.fee_cycles);

        return {
          id: row.id,
          familyId: row.family_id,
          feeCycleId: row.fee_cycle_id,
          familyNumber: family?.legacy_family_number ?? "",
          familyCode: family?.family_code ?? "",
          students: familyStudents
            .map((student) => student.student_name ?? "")
            .filter(Boolean),
          classNames: familyStudents
            .map((student) => student.class_name ?? "")
            .filter(Boolean),
          fatherName: family?.guardian_name ?? "",
          phone: family?.phone ?? "",
          monthLabel: feeCycle?.label ?? "Unknown Month",
          monthKey: feeCycle?.month_key ?? "1970-01-01",
          tuitionFee: normalizeNumber(row.tuition_amount),
          otherCharges: normalizeNumber(row.other_charges),
          carriedForward: normalizeNumber(row.carry_forward_amount),
          amountReceived: normalizeNumber(row.amount_received),
          dueDate: feeCycle?.due_date ?? feeCycle?.month_key ?? "1970-01-10",
          note: row.note ?? "",
        } satisfies DashboardFamilyRecord;
      })
      .sort((left, right) => {
        const monthCompare = compareMonthKeys(left.monthKey, right.monthKey);

        if (monthCompare !== 0) {
          return monthCompare;
        }

        return left.familyNumber.localeCompare(right.familyNumber, undefined, {
          numeric: true,
          sensitivity: "base",
        });
      });

    if (records.length === 0) {
      return {
        records: mapFallbackRecords(),
        source: "fallback",
      };
    }

    return {
      records,
      source: "supabase",
    };
  } catch {
    return {
      records: mapFallbackRecords(),
      source: "fallback",
    };
  }
}
