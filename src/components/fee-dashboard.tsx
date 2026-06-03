"use client";

import { useMemo, useState } from "react";
import { AddStudentModal } from "@/components/add-student-modal";
import {
  ActionGroup,
  AlertBanner,
  btnAccent,
  btnOutline,
  btnPrimary,
  btnSoft,
  btnSuccess,
  EditField,
  FormSection,
  inputClass,
  Money,
  Panel,
  selectClass,
  StatCard,
  StatusBadge,
} from "@/components/dashboard-ui";
import { getArrears, getPaymentStatus, getTotalDue } from "@/lib/fee-math";
import { getSupabaseBrowserClient } from "@/lib/supabase/client";
import {
  buildFeeCyclesForYear,
  getCurrentBillingContext,
  getYearFromMonthKey,
} from "@/lib/fee-cycles";
import type { DashboardFamilyRecord, FeeCycleOption, PrintableSlip } from "@/types/fees";

const currency = new Intl.NumberFormat("en-PK");

type EditableRecord = DashboardFamilyRecord & {
  studentsText: string;
};

type FeeDashboardProps = {
  initialRecords: DashboardFamilyRecord[];
  initialFeeCycles: FeeCycleOption[];
  schoolName: string;
  dataSource: "supabase" | "fallback";
};

const supabase = getSupabaseBrowserClient();

function getNextFamilyCode(records: DashboardFamilyRecord[]) {
  const maxSequence = records.reduce((max, record) => {
    const match = record.familyCode.match(/EGSS-FAM-(\d+)/i);

    if (!match) {
      return max;
    }

    return Math.max(max, Number.parseInt(match[1], 10));
  }, 0);

  return `EGSS-FAM-${String(maxSequence + 1).padStart(4, "0")}`;
}

function formatStudentsForInput(students: string[]) {
  return students.join(", ");
}

function parseStudentsText(studentsText: string) {
  return studentsText
    .split(",")
    .map((student) => student.trim())
    .filter(Boolean);
}

function parseStudentShape(value: string) {
  const match = value.match(/^(.*?)(?:\(([^)]+)\))?$/);

  return {
    studentName: (match?.[1] ?? value).trim(),
    className: (match?.[2] ?? "").trim() || null,
  };
}

function distributeStudentFees(totalFee: number, students: ReturnType<typeof parseStudentShape>[]) {
  if (students.length === 0) {
    return [];
  }

  const evenShare = Math.floor((totalFee / students.length) * 100) / 100;
  let runningTotal = 0;

  return students.map((student, index) => {
    const isLast = index === students.length - 1;
    const monthlyFee = isLast ? Number((totalFee - runningTotal).toFixed(2)) : evenShare;

    runningTotal = Number((runningTotal + monthlyFee).toFixed(2));

    return {
      ...student,
      monthly_fee: monthlyFee,
    };
  });
}

function toEditableRecord(record: DashboardFamilyRecord): EditableRecord {
  return {
    ...record,
    studentsText: formatStudentsForInput(record.students),
  };
}

function resolveInitialMonthKey(
  records: DashboardFamilyRecord[],
  cycles: FeeCycleOption[],
) {
  const { monthKey: currentKey } = getCurrentBillingContext();
  const keys = new Set([
    ...records.map((record) => record.monthKey),
    ...cycles.map((cycle) => cycle.monthKey),
  ]);

  if (keys.has(currentKey)) {
    return currentKey;
  }

  const sorted = [...keys].sort(
    (left, right) => new Date(right).getTime() - new Date(left).getTime(),
  );

  return sorted[0] ?? "all";
}

export function FeeDashboard({
  initialRecords,
  initialFeeCycles,
  schoolName,
  dataSource,
}: FeeDashboardProps) {
  const currentBilling = useMemo(() => getCurrentBillingContext(), []);
  const [records, setRecords] = useState<EditableRecord[]>(() => initialRecords.map(toEditableRecord));
  const [selectedMonthKey, setSelectedMonthKey] = useState(() =>
    resolveInitialMonthKey(initialRecords, initialFeeCycles),
  );
  const [billingYear, setBillingYear] = useState(currentBilling.year);
  const [selectedId, setSelectedId] = useState(initialRecords[0]?.id ?? "");
  const [searchTerm, setSearchTerm] = useState("");
  const [feedback, setFeedback] = useState<string>("");
  const [savingId, setSavingId] = useState<string | null>(null);
  const [showAddStudent, setShowAddStudent] = useState(false);
  const [creatingMonths, setCreatingMonths] = useState(false);
  const [syncingCarryForward, setSyncingCarryForward] = useState(false);
  const [showAdminTools, setShowAdminTools] = useState(false);

  const feeCycleOptions = useMemo(() => {
    const seen = new Map<string, FeeCycleOption>();

    for (const cycle of initialFeeCycles) {
      seen.set(cycle.monthKey, cycle);
    }

    for (const record of records) {
      if (!seen.has(record.monthKey)) {
        seen.set(record.monthKey, {
          id: record.feeCycleId,
          monthKey: record.monthKey,
          label: record.monthLabel,
          dueDate: record.dueDate,
        });
      }
    }

    return [...seen.values()].sort(
      (left, right) => new Date(left.monthKey).getTime() - new Date(right.monthKey).getTime(),
    );
  }, [initialFeeCycles, records]);

  const monthOptions = useMemo(() => {
    return [
      { monthKey: "all", label: "All months" },
      ...feeCycleOptions
        .map((cycle) => ({ monthKey: cycle.monthKey, label: cycle.label }))
        .sort((left, right) => new Date(right.monthKey).getTime() - new Date(left.monthKey).getTime()),
    ];
  }, [feeCycleOptions]);

  const defaultFeeCycleId = useMemo(() => {
    if (selectedMonthKey !== "all") {
      return feeCycleOptions.find((cycle) => cycle.monthKey === selectedMonthKey)?.id;
    }

    return feeCycleOptions[0]?.id;
  }, [feeCycleOptions, selectedMonthKey]);

  const existingFamilyOptions = useMemo(() => {
    const seen = new Map<string, { familyId: string; familyNumber: string; familyCode: string; fatherName: string; phone: string }>();

    for (const record of records) {
      if (!seen.has(record.familyId)) {
        seen.set(record.familyId, {
          familyId: record.familyId,
          familyNumber: record.familyNumber,
          familyCode: record.familyCode,
          fatherName: record.fatherName,
          phone: record.phone,
        });
      }
    }

    return [...seen.values()].sort((left, right) =>
      left.familyNumber.localeCompare(right.familyNumber, undefined, { numeric: true }),
    );
  }, [records]);

  const availableYears = useMemo(() => {
    const years = new Set<number>([currentBilling.year]);

    for (const cycle of feeCycleOptions) {
      years.add(getYearFromMonthKey(cycle.monthKey));
    }

    return [...years].sort((left, right) => right - left);
  }, [feeCycleOptions, currentBilling.year]);

  const missingMonthKeys = useMemo(() => {
    const existing = new Set(
      feeCycleOptions
        .filter((cycle) => getYearFromMonthKey(cycle.monthKey) === billingYear)
        .map((cycle) => cycle.monthKey),
    );

    return buildFeeCyclesForYear(billingYear)
      .filter((cycle) => !existing.has(cycle.monthKey))
      .sort((left, right) => new Date(left.monthKey).getTime() - new Date(right.monthKey).getTime());
  }, [feeCycleOptions, billingYear]);

  const isCurrentMonthOpen = useMemo(
    () => feeCycleOptions.some((cycle) => cycle.monthKey === currentBilling.monthKey),
    [feeCycleOptions, currentBilling.monthKey],
  );

  const selectedMonthLabel =
    monthOptions.find((option) => option.monthKey === selectedMonthKey)?.label ??
    currentBilling.label;

  const showMonthColumn = selectedMonthKey === "all";

  const filteredRecords = useMemo(() => {
    const normalizedSearch = searchTerm.trim().toLowerCase();

    return records.filter((record) => {
      const matchesMonth = selectedMonthKey === "all" || record.monthKey === selectedMonthKey;

      if (!matchesMonth) {
        return false;
      }

      if (!normalizedSearch) {
        return true;
      }

      const searchableText = [
        record.familyNumber,
        record.familyCode,
        record.fatherName,
        record.phone,
        record.students.join(", "),
        record.monthLabel,
      ]
        .join(" ")
        .toLowerCase();

      return searchableText.includes(normalizedSearch);
    });
  }, [records, searchTerm, selectedMonthKey]);

  const selectedRecord = filteredRecords.find((record) => record.id === selectedId) ?? filteredRecords[0] ?? null;

  const familyPendingMonths = useMemo(() => {
    const pendingByFamily = new Map<string, { monthKey: string; monthLabel: string }[]>();

    for (const record of records) {
      if (getArrears(record) <= 0) {
        continue;
      }

      const existing = pendingByFamily.get(record.familyId) ?? [];
      const alreadyIncluded = existing.some((item) => item.monthKey === record.monthKey);

      if (!alreadyIncluded) {
        existing.push({
          monthKey: record.monthKey,
          monthLabel: record.monthLabel,
        });
      }

      pendingByFamily.set(record.familyId, existing);
    }

    for (const [familyId, pendingMonths] of pendingByFamily.entries()) {
      pendingMonths.sort(
        (left, right) => new Date(left.monthKey).getTime() - new Date(right.monthKey).getTime(),
      );
      pendingByFamily.set(familyId, pendingMonths);
    }

    return pendingByFamily;
  }, [records]);

  const monthTotals = useMemo(() => {
    return filteredRecords.reduce(
      (summary, record) => {
        summary.totalDue += getTotalDue(record);
        summary.collected += record.amountReceived;
        summary.balance += getArrears(record);
        summary.annualFund += record.annualFund;
        return summary;
      },
      { totalDue: 0, collected: 0, balance: 0, annualFund: 0 },
    );
  }, [filteredRecords]);

  const printableSlip = useMemo<PrintableSlip | null>(() => {
    if (!selectedRecord) {
      return null;
    }

    const issueDate = new Date().toLocaleDateString("en-GB");
    const classLabel = selectedRecord.classNames[0] || "-";
    const studentLabel = selectedRecord.students.join(", ") || "-";

    return {
      schoolName,
      receiptId: selectedRecord.id.replace(/-/g, "").slice(0, 8).toUpperCase(),
      operator: "Admin",
      monthLabel: selectedRecord.monthLabel,
      familyNumber: selectedRecord.familyNumber,
      students: selectedRecord.students,
      studentLabel,
      fatherName: selectedRecord.fatherName,
      phone: selectedRecord.phone || "-",
      issueDate,
      paymentDate: issueDate,
      dueDate: new Date(selectedRecord.dueDate).toLocaleDateString("en-GB"),
      classLabel,
      sectionLabel: "-",
      rollNumber: "-",
      tuitionFee: selectedRecord.tuitionFee,
      otherCharges: selectedRecord.otherCharges,
      annualFund: selectedRecord.annualFund,
      carriedForward: selectedRecord.carriedForward,
      totalDue: getTotalDue(selectedRecord),
      amountReceived: selectedRecord.amountReceived,
      arrears: getArrears(selectedRecord),
    };
  }, [schoolName, selectedRecord]);

  function updateRecord<T extends keyof EditableRecord>(id: string, field: T, value: EditableRecord[T]) {
    setRecords((current) =>
      current.map((record) => (record.id === id ? { ...record, [field]: value } : record)),
    );
  }

  async function saveRecord(record: EditableRecord) {
    if (dataSource !== "supabase") {
      setFeedback(
        "Live Supabase access is not enabled for this app yet. Run the RLS policy SQL, then reload the page.",
      );
      return;
    }

    setFeedback("");
    setSavingId(record.id);

    const students = parseStudentsText(record.studentsText);
    const studentRows = distributeStudentFees(
      record.tuitionFee,
      students.map(parseStudentShape),
    );
    const totalDue = getTotalDue(record);
    const arrears = getArrears(record);
    const familyPayload = {
      legacy_family_number: record.familyNumber,
      guardian_name: record.fatherName,
      phone: record.phone || null,
    };
    const monthlyPayload = {
      tuition_amount: record.tuitionFee,
      other_charges: record.otherCharges,
      annual_fund_amount: record.annualFund,
      carry_forward_amount: record.carriedForward,
      total_due: totalDue,
      arrears_amount: arrears,
      note: record.note || null,
    };
    const cyclePayload = {
      due_date: record.dueDate,
    };
    const studentPayload = studentRows.map((student) => ({
      family_id: record.familyId,
      student_name: student.studentName,
      class_name: student.className,
      monthly_fee: student.monthly_fee,
      is_active: true,
    }));
    const paymentPayload = {
      monthly_fee_record_id: record.id,
      amount: record.amountReceived,
      payment_date: new Date().toISOString().slice(0, 10),
      payment_method: "dashboard-edit",
      note: "Saved from admin table",
    };

    try {
      const familyUpdate = await supabase
        .from("families")
        .update(familyPayload as never)
        .eq("id", record.familyId);

      if (familyUpdate.error) {
        throw new Error(`Could not save family ${record.familyNumber}.`);
      }

      const monthlyUpdate = await supabase
        .from("monthly_fee_records")
        .update(monthlyPayload as never)
        .eq("id", record.id);

      if (monthlyUpdate.error) {
        throw new Error(`Could not save monthly record for family ${record.familyNumber}.`);
      }

      const cycleUpdate = await supabase
        .from("fee_cycles")
        .update(cyclePayload as never)
        .eq("id", record.feeCycleId);

      if (cycleUpdate.error) {
        throw new Error(`Could not save due date for ${record.monthLabel}.`);
      }

      const studentDelete = await supabase.from("students").delete().eq("family_id", record.familyId);

      if (studentDelete.error) {
        throw new Error(`Could not refresh students for family ${record.familyNumber}.`);
      }

      if (studentRows.length > 0) {
        const studentInsert = await supabase.from("students").insert(studentPayload as never);

        if (studentInsert.error) {
          throw new Error(`Could not save students for family ${record.familyNumber}.`);
        }
      }

      const paymentDelete = await supabase.from("payments").delete().eq("monthly_fee_record_id", record.id);

      if (paymentDelete.error) {
        throw new Error(`Could not refresh payment for family ${record.familyNumber}.`);
      }

      if (record.amountReceived > 0) {
        const paymentInsert = await supabase.from("payments").insert(paymentPayload as never);

        if (paymentInsert.error) {
          throw new Error(`Could not save payment for family ${record.familyNumber}.`);
        }
      }

      setRecords((current) =>
        current.map((currentRecord) => {
          if (currentRecord.id === record.id) {
            return {
              ...record,
              students,
              classNames: studentRows
                .map((student) => student.className ?? "")
                .filter(Boolean),
              studentsText: formatStudentsForInput(students),
            };
          }

          if (currentRecord.feeCycleId === record.feeCycleId) {
            return {
              ...currentRecord,
              dueDate: record.dueDate,
            };
          }

          return currentRecord;
        }),
      );

      setFeedback(`Saved family ${record.familyNumber}.`);
    } catch (error) {
      setFeedback(error instanceof Error ? error.message : "Could not save the row.");
    } finally {
      setSavingId(null);
    }
  }

  function isDuplicateFeeCycleError(message: string) {
    return /fee_cycles_month_key|duplicate key.*month_key/i.test(message);
  }

  async function createFeeCycle(cycle: { monthKey: string; label: string; dueDate: string }) {
    const { error } = await supabase.rpc("create_next_fee_cycle", {
      next_month: cycle.monthKey,
      next_label: cycle.label,
      next_due_date: cycle.dueDate,
    } as never);

    if (!error) {
      return { alreadyExists: false };
    }

    if (isDuplicateFeeCycleError(error.message)) {
      return { alreadyExists: true };
    }

    throw new Error(error.message);
  }

  async function createCurrentMonth() {
    if (dataSource !== "supabase") {
      setFeedback("Connect to Supabase before opening a fee month.");
      return;
    }

    setCreatingMonths(true);
    setFeedback("");

    try {
      const result = await createFeeCycle(currentBilling.cycle);
      setCreatingMonths(false);
      const synced = await syncCarryForward(currentBilling.year);

      if (!synced) {
        setFeedback(
          (current) =>
            `${result.alreadyExists ? `${currentBilling.label} was already open.` : `Opened ${currentBilling.label}.`} ${current} Use the Month dropdown to edit or print.`,
        );
        setSelectedMonthKey(currentBilling.monthKey);
        window.location.reload();
        return;
      }

      if (result.alreadyExists) {
        setFeedback(`${currentBilling.label} was already open. Balances synced.`);
      }
    } catch (monthError) {
      setFeedback(monthError instanceof Error ? monthError.message : "Could not open this month.");
      setCreatingMonths(false);
    }
  }

  async function syncCarryForward(year = currentBilling.year) {
    if (dataSource !== "supabase") {
      setFeedback("Connect to Supabase before syncing carry-forward.");
      return false;
    }

    setSyncingCarryForward(true);

    const { error } = await supabase.rpc("recalculate_carry_forward", {
      year_value: year,
    } as never);

    setSyncingCarryForward(false);

    if (error) {
      const needsSql = /could not find the function|schema cache/i.test(error.message);
      setFeedback(
        needsSql
          ? "Carry-forward function is not installed yet. Open Supabase → SQL Editor, run the file supabase/recalculate_carry_forward.sql, then click Sync Previous Balances again."
          : `Carry-forward sync failed: ${error.message}`,
      );
      return false;
    }

    setFeedback(`Synced previous-month balances for ${year}. Reloading...`);
    window.location.reload();
    return true;
  }

  async function createMissingMonths() {
    if (dataSource !== "supabase") {
      setFeedback("Connect to Supabase before creating fee months.");
      return;
    }

    if (missingMonthKeys.length === 0) {
      setFeedback(`All 12 months for ${billingYear} are already in the database.`);
      return;
    }

    setCreatingMonths(true);
    setFeedback("");

    try {
      let skippedExisting = 0;

      for (const cycle of missingMonthKeys) {
        const result = await createFeeCycle(cycle);
        if (result.alreadyExists) {
          skippedExisting += 1;
        }
      }

      setCreatingMonths(false);
      const synced = await syncCarryForward(billingYear);

      if (!synced) {
        const createdCount = missingMonthKeys.length - skippedExisting;
        setFeedback(
          (current) =>
            `${createdCount > 0 ? `Created ${createdCount} month(s).` : "Months already existed."} ${skippedExisting > 0 ? `${skippedExisting} skipped (already in database). ` : ""}${current}`,
        );
        window.location.reload();
      }
    } catch (monthError) {
      setFeedback(monthError instanceof Error ? monthError.message : "Could not create fee months.");
      setCreatingMonths(false);
    }
  }

  function handleStudentCreated(record: DashboardFamilyRecord) {
    const editable = toEditableRecord(record);
    setRecords((current) => {
      const existingIndex = current.findIndex(
        (row) => row.id === record.id || (row.familyId === record.familyId && row.feeCycleId === record.feeCycleId),
      );

      if (existingIndex >= 0) {
        return current.map((row, index) => (index === existingIndex ? editable : row));
      }

      return [...current, editable];
    });
    setSelectedId(record.id);
    setSelectedMonthKey(record.monthKey);
    setShowAddStudent(false);
    setFeedback(`Saved student for family ${record.familyNumber || record.familyCode}.`);
  }

  return (
    <main className="min-h-screen overflow-x-hidden bg-slate-100/80 px-4 py-5 text-slate-900 sm:px-6 lg:px-8">
      <div className="mx-auto flex max-w-[1600px] min-w-0 flex-col gap-4">
        <Panel className="print-hidden overflow-hidden">
          <div className="border-b border-slate-100 bg-gradient-to-r from-slate-900 to-slate-800 px-5 py-5 text-white sm:px-6">
            <div className="flex flex-wrap items-start justify-between gap-4">
              <div>
                <p className="text-xs font-medium uppercase tracking-widest text-slate-300">
                  Fee Management
                </p>
                <h1 className="mt-1 text-2xl font-bold tracking-tight sm:text-3xl">{schoolName}</h1>
                <p className="mt-1 text-sm text-slate-300">Sheikhupura · {selectedMonthLabel}</p>
              </div>
              <span
                className={`rounded-full px-3 py-1 text-xs font-semibold ${
                  dataSource === "supabase"
                    ? "bg-emerald-500/20 text-emerald-100 ring-1 ring-emerald-400/40"
                    : "bg-amber-500/20 text-amber-100 ring-1 ring-amber-400/40"
                }`}
              >
                {dataSource === "supabase" ? "Live database" : "Offline demo data"}
              </span>
            </div>
          </div>

          <div className="grid gap-3 p-4 sm:grid-cols-2 lg:grid-cols-5 sm:p-5">
            <StatCard label="Families shown" value={String(filteredRecords.length)} tone="blue" />
            <StatCard
              label="Monthly fees"
              value={`Rs. ${currency.format(filteredRecords.reduce((sum, r) => sum + r.tuitionFee, 0))}`}
              tone="neutral"
            />
            <StatCard
              label="Annual fund"
              value={`Rs. ${currency.format(monthTotals.annualFund)}`}
              tone="amber"
            />
            <StatCard
              label="Total due"
              value={`Rs. ${currency.format(monthTotals.totalDue)}`}
              tone="neutral"
            />
            <StatCard
              label="Outstanding"
              value={`Rs. ${currency.format(monthTotals.balance)}`}
              tone="rose"
              hint={`Collected: Rs. ${currency.format(monthTotals.collected)}`}
            />
          </div>

          <div className="border-t border-slate-100 px-4 py-4 sm:px-5">
            <div className="grid gap-3 lg:grid-cols-[1fr_auto] lg:items-end">
              <div className="grid gap-3 sm:grid-cols-3">
                <EditField label="Search families">
                  <input
                    value={searchTerm}
                    onChange={(event) => setSearchTerm(event.target.value)}
                    placeholder="Family no, name, student..."
                    className={inputClass}
                  />
                </EditField>
                <EditField label="Year">
                  <select
                    value={billingYear}
                    onChange={(event) => setBillingYear(Number(event.target.value))}
                    className={selectClass}
                  >
                    {availableYears.map((year) => (
                      <option key={year} value={year}>
                        {year}
                      </option>
                    ))}
                  </select>
                </EditField>
                <EditField label="View month">
                  <select
                    value={selectedMonthKey}
                    onChange={(event) => setSelectedMonthKey(event.target.value)}
                    className={selectClass}
                  >
                    {monthOptions.map((option) => (
                      <option key={option.monthKey} value={option.monthKey}>
                        {option.label}
                      </option>
                    ))}
                  </select>
                </EditField>
              </div>

              <div className="flex flex-wrap gap-2">
                <button type="button" className={btnPrimary} onClick={() => window.print()}>
                  Print receipt
                </button>
                {dataSource === "supabase" ? (
                  <button
                    type="button"
                    className={btnSuccess}
                    onClick={() => setShowAddStudent(true)}
                    disabled={feeCycleOptions.length === 0 || selectedMonthKey === "all"}
                  >
                    + Add student
                  </button>
                ) : null}
              </div>
            </div>

            {dataSource === "supabase" ? (
              <div className="mt-4 space-y-3">
                <ActionGroup label="Quick actions">
                  {!isCurrentMonthOpen ? (
                    <button
                      type="button"
                      className={btnAccent}
                      onClick={() => void createCurrentMonth()}
                      disabled={creatingMonths}
                    >
                      {creatingMonths ? "Opening…" : `Open ${currentBilling.label}`}
                    </button>
                  ) : null}
                  <button
                    type="button"
                    className={btnSoft}
                    onClick={() => {
                      setSelectedMonthKey(currentBilling.monthKey);
                      setBillingYear(currentBilling.year);
                    }}
                  >
                    Today: {currentBilling.label}
                  </button>
                </ActionGroup>

                <button
                  type="button"
                  className="text-xs font-semibold text-slate-500 hover:text-slate-800"
                  onClick={() => setShowAdminTools((current) => !current)}
                >
                  {showAdminTools ? "▾ Hide admin tools" : "▸ Admin tools (months & balances)"}
                </button>

                {showAdminTools ? (
                  <ActionGroup label="Admin">
                    <button
                      type="button"
                      className={btnOutline}
                      onClick={() => void createMissingMonths()}
                      disabled={creatingMonths || missingMonthKeys.length === 0}
                    >
                      {creatingMonths
                        ? "Working…"
                        : missingMonthKeys.length > 0
                          ? `Create ${missingMonthKeys.length} months (${billingYear})`
                          : `${billingYear} — all months exist`}
                    </button>
                    <button
                      type="button"
                      className={btnOutline}
                      onClick={() => void syncCarryForward(billingYear)}
                      disabled={syncingCarryForward}
                    >
                      {syncingCarryForward ? "Syncing…" : "Sync previous balances"}
                    </button>
                  </ActionGroup>
                ) : null}
              </div>
            ) : null}
          </div>

          <div className="space-y-3 border-t border-slate-100 px-4 pb-4 sm:px-5 sm:pb-5">
            {dataSource === "supabase" && !isCurrentMonthOpen ? (
              <AlertBanner tone="info">
                <strong>{currentBilling.label}</strong> is not set up yet. Click{" "}
                <strong>Open {currentBilling.label}</strong> to bill all families. Last month&apos;s
                unpaid balance will carry forward automatically.
              </AlertBanner>
            ) : null}
            {dataSource === "supabase" && isCurrentMonthOpen && selectedMonthKey !== "all" ? (
              <AlertBanner tone="success">
                Working on <strong>{selectedMonthLabel}</strong> — select a row in the table, edit on
                the right, save, then print.
              </AlertBanner>
            ) : null}
            {dataSource !== "supabase" ? (
              <AlertBanner tone="warning">
                Demo data only. Connect Supabase and add API policies to enable saving.
              </AlertBanner>
            ) : null}
            {feedback ? <AlertBanner tone="neutral">{feedback}</AlertBanner> : null}
          </div>
        </Panel>

        <section className="grid min-w-0 gap-4 xl:grid-cols-[minmax(0,1.65fr)_minmax(360px,1fr)]">
          <Panel className="print-hidden min-w-0 overflow-hidden">
            <div className="flex flex-wrap items-center justify-between gap-3 border-b border-slate-100 px-4 py-3 sm:px-5">
              <div>
                <h2 className="text-base font-bold text-slate-900">Family fee records</h2>
                <p className="text-xs text-slate-500">Click a row to edit · {selectedMonthLabel}</p>
              </div>
              {selectedRecord ? <StatusBadge status={getPaymentStatus(selectedRecord)} /> : null}
            </div>

            <div className="overflow-x-auto">
              <table className="w-full min-w-[860px] border-collapse text-left text-sm">
                <thead className="sticky top-0 z-10 bg-slate-100 text-xs uppercase tracking-wide text-slate-600">
                  <tr>
                    <th className="px-4 py-3 font-bold">Family</th>
                    <th className="px-4 py-3 font-bold">Students</th>
                    {showMonthColumn ? <th className="px-4 py-3 font-bold">Month</th> : null}
                    <th className="px-4 py-3 text-right font-bold">Monthly</th>
                    <th className="px-4 py-3 text-right font-bold">Annual Fund</th>
                    <th className="px-4 py-3 text-right font-bold">Total Due</th>
                    <th className="px-4 py-3 text-right font-bold">Paid</th>
                    <th className="px-4 py-3 text-right font-bold">Balance</th>
                    <th className="px-4 py-3 font-bold">Status</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredRecords.map((record, index) => {
                    const status = getPaymentStatus(record);
                    const isSelected = record.id === selectedRecord?.id;

                    return (
                      <tr
                        key={record.id}
                        className={`cursor-pointer border-t border-slate-100 transition ${
                          isSelected
                            ? "bg-blue-50 ring-1 ring-inset ring-blue-200"
                            : index % 2 === 0
                              ? "bg-white hover:bg-slate-50"
                              : "bg-slate-50/50 hover:bg-slate-50"
                        }`}
                        onClick={() => setSelectedId(record.id)}
                      >
                        <td className="px-4 py-3 align-top">
                          <p className="font-bold text-slate-900">#{record.familyNumber || "—"}</p>
                          <p className="mt-0.5 text-sm text-slate-700">{record.fatherName || "—"}</p>
                          <p className="mt-0.5 text-xs text-slate-400">{record.phone || "No phone"}</p>
                        </td>
                        <td className="max-w-[200px] px-4 py-3 align-top text-slate-700">
                          {record.students.join(", ") || "—"}
                        </td>
                        {showMonthColumn ? (
                          <td className="px-4 py-3 align-top">
                            <span className="rounded-md bg-slate-200/80 px-2 py-1 text-xs font-medium text-slate-700">
                              {record.monthLabel}
                            </span>
                          </td>
                        ) : null}
                        <td className="px-4 py-3 text-right align-top text-slate-700">
                          <Money amount={record.tuitionFee} />
                        </td>
                        <td className="px-4 py-3 text-right align-top">
                          {record.annualFund > 0 ? (
                            <Money amount={record.annualFund} />
                          ) : (
                            <span className="text-slate-400">—</span>
                          )}
                        </td>
                        <td className="px-4 py-3 text-right align-top">
                          <Money amount={getTotalDue(record)} />
                        </td>
                        <td className="px-4 py-3 text-right align-top text-slate-600">
                          <Money amount={record.amountReceived} />
                        </td>
                        <td className="px-4 py-3 text-right align-top">
                          <Money amount={getArrears(record)} />
                        </td>
                        <td className="px-4 py-3 align-top">
                          <StatusBadge status={status} />
                        </td>
                      </tr>
                    );
                  })}
                  {filteredRecords.length === 0 ? (
                    <tr>
                      <td
                        colSpan={showMonthColumn ? 9 : 8}
                        className="px-4 py-12 text-center text-sm text-slate-500"
                      >
                        No families for this month. Try another month or add a student.
                      </td>
                    </tr>
                  ) : null}
                </tbody>
              </table>
            </div>
          </Panel>

          <div className="min-w-0 space-y-4 xl:sticky xl:top-4 xl:self-start">
            {selectedRecord ? (
              <Panel className="print-hidden p-4 sm:p-5">
                <div className="flex items-start justify-between gap-3 border-b border-slate-100 pb-4">
                  <div>
                    <p className="text-xs font-bold uppercase tracking-wide text-slate-400">
                      Editing
                    </p>
                    <h2 className="text-lg font-bold text-slate-900">
                      Family #{selectedRecord.familyNumber || "—"}
                    </h2>
                    <p className="text-sm text-slate-600">{selectedRecord.fatherName}</p>
                  </div>
                  <span className="shrink-0 rounded-lg bg-blue-100 px-2.5 py-1 text-xs font-bold text-blue-900">
                    {selectedRecord.monthLabel}
                  </span>
                </div>

                <div className="mt-4 grid grid-cols-3 gap-2">
                  <div className="rounded-lg border border-slate-200 bg-slate-50 px-2 py-2 text-center">
                    <p className="text-[10px] font-bold uppercase text-slate-400">Due</p>
                    <p className="mt-0.5 text-sm font-bold tabular-nums">
                      {currency.format(getTotalDue(selectedRecord))}
                    </p>
                  </div>
                  <div className="rounded-lg border border-emerald-200 bg-emerald-50 px-2 py-2 text-center">
                    <p className="text-[10px] font-bold uppercase text-emerald-600">Paid</p>
                    <p className="mt-0.5 text-sm font-bold tabular-nums text-emerald-900">
                      {currency.format(selectedRecord.amountReceived)}
                    </p>
                  </div>
                  <div className="rounded-lg border border-rose-200 bg-rose-50 px-2 py-2 text-center">
                    <p className="text-[10px] font-bold uppercase text-rose-600">Balance</p>
                    <p className="mt-0.5 text-sm font-bold tabular-nums text-rose-900">
                      {currency.format(getArrears(selectedRecord))}
                    </p>
                  </div>
                </div>

                <div className="mt-4 space-y-4">
                  <FormSection title="Family" description="Guardian and contact details">
                    <div className="grid gap-3 sm:grid-cols-2">
                      <EditField label="Family no">
                        <input
                          value={selectedRecord.familyNumber}
                          onChange={(event) =>
                            updateRecord(selectedRecord.id, "familyNumber", event.target.value)
                          }
                          className={inputClass}
                        />
                      </EditField>
                      <EditField label="Phone">
                        <input
                          value={selectedRecord.phone}
                          onChange={(event) =>
                            updateRecord(selectedRecord.id, "phone", event.target.value)
                          }
                          className={inputClass}
                        />
                      </EditField>
                      <EditField label="Guardian name" className="sm:col-span-2">
                        <input
                          value={selectedRecord.fatherName}
                          onChange={(event) =>
                            updateRecord(selectedRecord.id, "fatherName", event.target.value)
                          }
                          className={inputClass}
                        />
                      </EditField>
                      <EditField label="Due date">
                        <input
                          type="date"
                          value={selectedRecord.dueDate}
                          onChange={(event) =>
                            updateRecord(selectedRecord.id, "dueDate", event.target.value)
                          }
                          className={inputClass}
                        />
                      </EditField>
                    </div>
                  </FormSection>

                  <FormSection title="Students" description="Comma-separated names">
                    <textarea
                      value={selectedRecord.studentsText}
                      rows={3}
                      onChange={(event) =>
                        updateRecord(selectedRecord.id, "studentsText", event.target.value)
                      }
                      className={inputClass}
                    />
                  </FormSection>

                  <FormSection title="Fees" description="Amounts in rupees">
                    <div className="grid gap-3 sm:grid-cols-2">
                      <EditField label="Monthly fee">
                        <input
                          type="number"
                          value={selectedRecord.tuitionFee}
                          onChange={(event) =>
                            updateRecord(selectedRecord.id, "tuitionFee", Number(event.target.value || 0))
                          }
                          className={inputClass}
                        />
                      </EditField>
                      <EditField label="Annual fund">
                        <input
                          type="number"
                          value={selectedRecord.annualFund}
                          onChange={(event) =>
                            updateRecord(selectedRecord.id, "annualFund", Number(event.target.value || 0))
                          }
                          className={inputClass}
                        />
                      </EditField>
                      <EditField label="Other charges">
                        <input
                          type="number"
                          value={selectedRecord.otherCharges}
                          onChange={(event) =>
                            updateRecord(selectedRecord.id, "otherCharges", Number(event.target.value || 0))
                          }
                          className={inputClass}
                        />
                      </EditField>
                      <EditField
                        label="Previous balance"
                        hint="From last month's unpaid amount"
                      >
                        <input
                          type="number"
                          value={selectedRecord.carriedForward}
                          onChange={(event) =>
                            updateRecord(
                              selectedRecord.id,
                              "carriedForward",
                              Number(event.target.value || 0),
                            )
                          }
                          className={inputClass}
                        />
                      </EditField>
                      <EditField label="Received" className="sm:col-span-2">
                        <input
                          type="number"
                          value={selectedRecord.amountReceived}
                          onChange={(event) =>
                            updateRecord(
                              selectedRecord.id,
                              "amountReceived",
                              Number(event.target.value || 0),
                            )
                          }
                          className={inputClass}
                        />
                      </EditField>
                    </div>
                  </FormSection>

                  {(familyPendingMonths.get(selectedRecord.familyId) ?? []).length > 0 ? (
                    <AlertBanner tone="warning">
                      Unpaid in other months:{" "}
                      {(familyPendingMonths.get(selectedRecord.familyId) ?? [])
                        .map((item) => item.monthLabel)
                        .join(", ")}
                    </AlertBanner>
                  ) : null}

                  <EditField label="Note">
                    <textarea
                      value={selectedRecord.note ?? ""}
                      onChange={(event) => updateRecord(selectedRecord.id, "note", event.target.value)}
                      className={`${inputClass} min-h-20`}
                      placeholder="Optional note for this month"
                    />
                  </EditField>
                </div>

                <div className="mt-5 flex flex-wrap gap-2 border-t border-slate-100 pt-4">
                  <button
                    type="button"
                    className={`${btnPrimary} flex-1`}
                    onClick={() => void saveRecord(selectedRecord)}
                    disabled={savingId === selectedRecord.id || dataSource !== "supabase"}
                  >
                    {savingId === selectedRecord.id ? "Saving…" : "Save changes"}
                  </button>
                  <button type="button" className={btnOutline} onClick={() => window.print()}>
                    Print
                  </button>
                </div>
              </Panel>
            ) : (
              <Panel className="print-hidden p-8 text-center text-sm text-slate-500">
                Select a family from the table to edit fees and print a receipt.
              </Panel>
            )}

            {printableSlip ? <SlipPreview slip={printableSlip} /> : null}
          </div>
        </section>
      </div>

      {dataSource === "supabase" ? (
        <AddStudentModal
          open={showAddStudent}
          feeCycles={feeCycleOptions}
          existingFamilies={existingFamilyOptions}
          nextFamilyCode={getNextFamilyCode(records)}
          defaultFeeCycleId={defaultFeeCycleId}
          onClose={() => setShowAddStudent(false)}
          onCreated={handleStudentCreated}
        />
      ) : null}
    </main>
  );
}

function SlipPreview({ slip }: { slip: PrintableSlip }) {
  return (
    <section className="receipt-shell print-card mx-auto w-full max-w-[760px] rounded-[18px] bg-white px-4 py-5 shadow-[0_16px_40px_rgba(15,23,42,0.06)] sm:px-6 sm:py-6">
      <div className="receipt-frame rounded-[28px] border border-slate-300 px-5 py-5 sm:px-7 sm:py-6">
        <div className="text-left">
          <p className="text-[15px] font-semibold text-slate-800">Parent Copy</p>
        </div>

        <div className="mt-2 text-center">
          <h2 className="text-[30px] font-semibold tracking-tight text-slate-900">
            {slip.schoolName}
          </h2>
          <p className="mt-1 text-sm text-slate-500">Sheikhupura</p>
        </div>

        <div className="mt-6 border-t border-dashed border-slate-300 pt-4">
          <ReceiptFieldRow label="Printing Date" value={slip.issueDate} />
          <ReceiptFieldRow label="Payment Date" value={slip.paymentDate} />
          <ReceiptFieldRow label="Receipt ID" value={slip.receiptId} />
          <ReceiptFieldRow label="Operator" value={slip.operator} />
        </div>

        <div className="mt-5 border-t border-dashed border-slate-300 pt-4">
          <ReceiptFieldRow label="Student" value={slip.studentLabel} />
          <ReceiptFieldRow label="Father Name" value={slip.fatherName} />
          <ReceiptFieldRow label="Family ID" value={slip.familyNumber} />
          <ReceiptFieldRow label="Roll No" value={slip.rollNumber} />
          <ReceiptFieldRow label="Class" value={slip.classLabel} />
          <ReceiptFieldRow label="Section" value={slip.sectionLabel} />
        </div>

        <div className="mt-6 overflow-hidden rounded-[18px] border border-slate-300">
          <div className="border-b border-slate-300 bg-white px-4 py-3 text-center text-[15px] font-semibold text-slate-700">
            Receipt Detail
          </div>
          <table className="min-w-full border-collapse text-[15px]">
            <tbody>
              <SlipRow
                label={`Monthly Fee: ${slip.monthLabel}`}
                value={currency.format(slip.tuitionFee)}
              />
              <SlipRow label="Other Charges" value={currency.format(slip.otherCharges)} />
              <SlipRow label="Annual Fund" value={currency.format(slip.annualFund)} />
              <SlipRow
                label="Pending Fee Up To Previous Month"
                value={currency.format(slip.carriedForward)}
              />
              <SlipRow label="Total" value={currency.format(slip.totalDue)} emphasized />
              <SlipRow label="Received amount" value={currency.format(slip.amountReceived)} emphasized />
              <SlipRow label="Balance" value={currency.format(slip.arrears)} emphasized />
              <SlipRow label="Available Advance" value="0.00" />
            </tbody>
          </table>
        </div>

        <div className="mt-6 text-sm text-slate-500">
          This is computer generated report no signature required
        </div>
      </div>
    </section>
  );
}

function ReceiptFieldRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-start justify-between gap-6 py-1.5 text-[15px]">
      <span className="text-slate-600">{label}:</span>
      <span className="text-right font-medium text-slate-900">{value}</span>
    </div>
  );
}

function SlipRow({
  label,
  value,
  emphasized = false,
}: {
  label: string;
  value: string;
  emphasized?: boolean;
}) {
  return (
    <tr className="border-t border-slate-300">
      <td className={`px-4 py-3 ${emphasized ? "font-semibold text-slate-900" : "text-slate-700"}`}>
        {label}
      </td>
      <td
        className={`px-4 py-3 text-right ${emphasized ? "font-semibold text-slate-900" : "text-slate-700"}`}
      >
        {value}
      </td>
    </tr>
  );
}
