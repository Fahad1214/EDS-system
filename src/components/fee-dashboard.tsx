"use client";

import { useMemo, useState } from "react";
import { getSupabaseBrowserClient } from "@/lib/supabase/client";
import type { DashboardFamilyRecord, PrintableSlip } from "@/types/fees";

const currency = new Intl.NumberFormat("en-PK");

const statusStyles = {
  paid: "bg-emerald-100 text-emerald-800",
  partial: "bg-amber-100 text-amber-800",
  pending: "bg-rose-100 text-rose-800",
};

type EditableRecord = DashboardFamilyRecord & {
  studentsText: string;
};

type FeeDashboardProps = {
  initialRecords: DashboardFamilyRecord[];
  schoolName: string;
  dataSource: "supabase" | "fallback";
};

const supabase = getSupabaseBrowserClient();

function getTotalDue(record: Pick<DashboardFamilyRecord, "tuitionFee" | "otherCharges" | "carriedForward">) {
  return record.tuitionFee + record.otherCharges + record.carriedForward;
}

function getArrears(
  record: Pick<
    DashboardFamilyRecord,
    "tuitionFee" | "otherCharges" | "carriedForward" | "amountReceived"
  >,
) {
  return Math.max(getTotalDue(record) - record.amountReceived, 0);
}

function getStatus(
  record: Pick<
    DashboardFamilyRecord,
    "tuitionFee" | "otherCharges" | "carriedForward" | "amountReceived"
  >,
) {
  const arrears = getArrears(record);

  if (arrears === 0) {
    return "paid" as const;
  }

  if (record.amountReceived > 0) {
    return "partial" as const;
  }

  return "pending" as const;
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

export function FeeDashboard({ initialRecords, schoolName, dataSource }: FeeDashboardProps) {
  const [records, setRecords] = useState<EditableRecord[]>(() => initialRecords.map(toEditableRecord));
  const [selectedMonthKey, setSelectedMonthKey] = useState(initialRecords[0]?.monthKey ?? "all");
  const [selectedId, setSelectedId] = useState(initialRecords[0]?.id ?? "");
  const [searchTerm, setSearchTerm] = useState("");
  const [feedback, setFeedback] = useState<string>("");
  const [savingId, setSavingId] = useState<string | null>(null);

  const monthOptions = useMemo(() => {
    const seen = new Map<string, string>();

    for (const record of records) {
      if (!seen.has(record.monthKey)) {
        seen.set(record.monthKey, record.monthLabel);
      }
    }

    return [{ monthKey: "all", label: "All months" }, ...[...seen.entries()]
      .map(([monthKey, label]) => ({ monthKey, label }))
      .sort((left, right) => new Date(right.monthKey).getTime() - new Date(left.monthKey).getTime())];
  }, [records]);

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
        return summary;
      },
      { totalDue: 0, collected: 0, balance: 0 },
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

  return (
    <main className="min-h-screen overflow-x-hidden px-4 py-6 text-slate-900 sm:px-6 lg:px-8">
      <div className="mx-auto flex max-w-7xl min-w-0 flex-col gap-5">
        <section className="print-hidden rounded-[24px] border border-slate-200 bg-white p-5 shadow-[0_16px_40px_rgba(15,23,42,0.06)]">
          <div className="flex flex-col gap-4 xl:flex-row xl:items-end xl:justify-between">
            <div className="space-y-2">
              <h1 className="text-3xl font-bold tracking-tight">{schoolName}</h1>
              <p className="text-sm text-slate-600">
                Minimal admin table for month-wise fee editing and receipt printing.
              </p>
              <div className="flex flex-wrap gap-2 text-xs font-medium">
                <span className="rounded-full bg-slate-100 px-3 py-1 text-slate-700">
                  Data: {dataSource === "supabase" ? "Live Supabase" : "Local fallback"}
                </span>
                <span className="rounded-full bg-slate-100 px-3 py-1 text-slate-700">
                  Rows: {filteredRecords.length}
                </span>
                <span className="rounded-full bg-slate-100 px-3 py-1 text-slate-700">
                  Balance: Rs. {currency.format(monthTotals.balance)}
                </span>
              </div>
            </div>

            <div className="flex flex-col gap-3 sm:flex-row">
              <label className="flex min-w-[240px] flex-1 flex-col gap-2 text-sm font-medium text-slate-700">
                Search
                <input
                  value={searchTerm}
                  onChange={(event) => setSearchTerm(event.target.value)}
                  placeholder="Search family, guardian, student..."
                  className="rounded-xl border border-slate-300 bg-white px-3 py-2 text-sm text-slate-900 outline-none ring-0"
                />
              </label>
              <label className="flex flex-col gap-2 text-sm font-medium text-slate-700">
                Month
                <select
                  value={selectedMonthKey}
                  onChange={(event) => setSelectedMonthKey(event.target.value)}
                  className="rounded-xl border border-slate-300 bg-white px-3 py-2 text-sm text-slate-900 outline-none ring-0"
                >
                  {monthOptions.map((option) => (
                    <option key={option.monthKey} value={option.monthKey}>
                      {option.label}
                    </option>
                  ))}
                </select>
              </label>

              <button
                type="button"
                onClick={() => window.print()}
                className="rounded-xl bg-slate-900 px-4 py-2 text-sm font-semibold text-white transition hover:bg-slate-800"
              >
                Print Selected Receipt
              </button>
            </div>
          </div>
          {dataSource !== "supabase" ? (
            <div className="mt-4 rounded-2xl border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-900">
              The dashboard is showing fallback imported data because Supabase API policies are not
              open for this app yet. Saving is disabled until those policies are added.
            </div>
          ) : null}
          {feedback ? (
            <div className="mt-4 rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm text-slate-700">
              {feedback}
            </div>
          ) : null}
        </section>

        <section className="grid min-w-0 gap-5 xl:grid-cols-[minmax(0,1.8fr)_minmax(320px,0.8fr)]">
          <div className="print-hidden min-w-0 rounded-[24px] border border-slate-200 bg-white p-4 shadow-[0_16px_40px_rgba(15,23,42,0.06)]">
            <div className="mb-3 flex flex-wrap items-center justify-between gap-3 px-1">
              <div>
                <h2 className="text-xl font-bold text-slate-900">Month Wise Editable Table</h2>
                <p className="text-sm text-slate-600">
                  Select a row to edit full details on the right.
                </p>
              </div>
              <div className="text-sm text-slate-600">
                Total Due: <strong>Rs. {currency.format(monthTotals.totalDue)}</strong> | Received:{" "}
                <strong>Rs. {currency.format(monthTotals.collected)}</strong>
              </div>
            </div>

            <div className="max-w-full overflow-hidden rounded-3xl border border-slate-200">
              <div className="w-full max-w-full overflow-x-auto">
                <table className="min-w-[980px] border-collapse text-left text-sm xl:min-w-full">
                  <thead className="bg-slate-50 text-slate-600">
                    <tr>
                      <th className="px-3 py-3 font-semibold">Family</th>
                      <th className="px-3 py-3 font-semibold">Students</th>
                      <th className="px-3 py-3 font-semibold">Month</th>
                      <th className="px-3 py-3 font-semibold">Total Due</th>
                      <th className="px-3 py-3 font-semibold">Received</th>
                      <th className="px-3 py-3 font-semibold">Balance</th>
                      <th className="px-3 py-3 font-semibold">Pending Months</th>
                      <th className="px-3 py-3 font-semibold">Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    {filteredRecords.map((record) => {
                      const status = getStatus(record);
                      const isSelected = record.id === selectedRecord?.id;
                      const pendingMonths = familyPendingMonths.get(record.familyId) ?? [];

                      return (
                        <tr
                          key={record.id}
                          className={`cursor-pointer border-t border-slate-100 transition hover:bg-blue-50/60 ${
                            isSelected ? "bg-blue-50/80" : "bg-white"
                          }`}
                          onClick={() => setSelectedId(record.id)}
                        >
                          <td className="px-3 py-3 align-top">
                            <p className="font-semibold text-slate-900">#{record.familyNumber || "-"}</p>
                            <p className="mt-1 text-sm text-slate-700">{record.fatherName || "-"}</p>
                            <p className="mt-1 text-[11px] text-slate-500">{record.familyCode}</p>
                          </td>
                          <td className="px-3 py-3 align-top">
                            <p className="max-w-[220px] leading-6 text-slate-700">
                              {record.students.join(", ") || "-"}
                            </p>
                          </td>
                          <td className="px-3 py-3 align-top">
                            <span className="inline-flex rounded-full bg-slate-100 px-3 py-1 text-xs font-semibold text-slate-700">
                              {record.monthLabel}
                            </span>
                          </td>
                          <td className="px-3 py-3 align-top">
                            <p className="font-semibold text-slate-900">
                              Rs. {currency.format(getTotalDue(record))}
                            </p>
                          </td>
                          <td className="px-3 py-3 align-top">
                            <p className="font-medium text-slate-700">
                              Rs. {currency.format(record.amountReceived)}
                            </p>
                          </td>
                          <td className="px-3 py-3 align-top">
                            <p className="font-semibold text-slate-900">
                              Rs. {currency.format(getArrears(record))}
                            </p>
                          </td>
                          <td className="px-3 py-3 align-top">
                            <div className="flex max-w-[220px] flex-wrap gap-1.5">
                              {pendingMonths.length > 0 ? (
                                pendingMonths.map((pendingMonth) => (
                                  <span
                                    key={`${record.familyId}-${pendingMonth.monthKey}`}
                                    className="inline-flex rounded-full bg-amber-100 px-2.5 py-1 text-[11px] font-semibold text-amber-800"
                                  >
                                    {pendingMonth.monthLabel}
                                  </span>
                                ))
                              ) : (
                                <span className="text-xs text-slate-400">None</span>
                              )}
                            </div>
                          </td>
                          <td className="px-3 py-3 align-top">
                            <span
                              className={`inline-flex rounded-full px-2.5 py-1 text-[11px] font-semibold capitalize ${statusStyles[status]}`}
                            >
                              {status}
                            </span>
                          </td>
                        </tr>
                      );
                    })}
                    {filteredRecords.length === 0 ? (
                      <tr>
                        <td colSpan={8} className="px-4 py-8 text-center text-sm text-slate-500">
                          No records found for this month.
                        </td>
                      </tr>
                    ) : null}
                  </tbody>
                </table>
              </div>
            </div>
          </div>

          <div className="min-w-0 space-y-4">
            {selectedRecord ? (
              <div className="print-hidden rounded-[24px] border border-slate-200 bg-white p-4 shadow-[0_16px_40px_rgba(15,23,42,0.06)]">
                <div className="flex items-start justify-between gap-3">
                  <div>
                    <h2 className="text-lg font-bold text-slate-900">Edit Selected Row</h2>
                    <p className="text-sm text-slate-600">
                      Update all fields here, then save changes.
                    </p>
                  </div>
                  <span className="inline-flex rounded-full bg-slate-100 px-3 py-1 text-xs font-semibold text-slate-700">
                    {selectedRecord.monthLabel}
                  </span>
                </div>

                <div className="mt-4 grid gap-3 sm:grid-cols-2">
                  <EditField label="Family No">
                    <input
                      value={selectedRecord.familyNumber}
                      onChange={(event) =>
                        updateRecord(selectedRecord.id, "familyNumber", event.target.value)
                      }
                      className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm text-slate-900"
                    />
                  </EditField>
                  <EditField label="Phone">
                    <input
                      value={selectedRecord.phone}
                      onChange={(event) =>
                        updateRecord(selectedRecord.id, "phone", event.target.value)
                      }
                      className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm text-slate-900"
                    />
                  </EditField>
                  <EditField label="Guardian">
                    <input
                      value={selectedRecord.fatherName}
                      onChange={(event) =>
                        updateRecord(selectedRecord.id, "fatherName", event.target.value)
                      }
                      className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm text-slate-900"
                    />
                  </EditField>
                  <EditField label="Due Date">
                    <input
                      type="date"
                      value={selectedRecord.dueDate}
                      onChange={(event) =>
                        updateRecord(selectedRecord.id, "dueDate", event.target.value)
                      }
                      className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm text-slate-900"
                    />
                  </EditField>
                </div>

                <EditField label="Students" className="mt-4">
                  <textarea
                    value={selectedRecord.studentsText}
                    rows={3}
                    onChange={(event) =>
                      updateRecord(selectedRecord.id, "studentsText", event.target.value)
                    }
                    className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm text-slate-900"
                  />
                </EditField>

                <div className="mt-4 grid gap-3 sm:grid-cols-2">
                  <EditField label="Monthly Fee">
                    <input
                      type="number"
                      value={selectedRecord.tuitionFee}
                      onChange={(event) =>
                        updateRecord(selectedRecord.id, "tuitionFee", Number(event.target.value || 0))
                      }
                      className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm text-slate-900"
                    />
                  </EditField>
                  <EditField label="Other Charges">
                    <input
                      type="number"
                      value={selectedRecord.otherCharges}
                      onChange={(event) =>
                        updateRecord(selectedRecord.id, "otherCharges", Number(event.target.value || 0))
                      }
                      className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm text-slate-900"
                    />
                  </EditField>
                  <EditField label="Pending Previous">
                    <input
                      type="number"
                      value={selectedRecord.carriedForward}
                      onChange={(event) =>
                        updateRecord(selectedRecord.id, "carriedForward", Number(event.target.value || 0))
                      }
                      className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm text-slate-900"
                    />
                  </EditField>
                  <EditField label="Received">
                    <input
                      type="number"
                      value={selectedRecord.amountReceived}
                      onChange={(event) =>
                        updateRecord(selectedRecord.id, "amountReceived", Number(event.target.value || 0))
                      }
                      className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm text-slate-900"
                    />
                  </EditField>
                </div>

                <div className="mt-4 space-y-3 text-sm">
                  <InfoRow label="Total Due" value={`Rs. ${currency.format(getTotalDue(selectedRecord))}`} />
                  <InfoRow label="Balance" value={`Rs. ${currency.format(getArrears(selectedRecord))}`} />
                  <InfoRow
                    label="Pending Months"
                    value={
                      (familyPendingMonths.get(selectedRecord.familyId) ?? [])
                        .map((item) => item.monthLabel)
                        .join(", ") || "None"
                    }
                  />
                </div>

                <EditField label="Note" className="mt-4">
                  <textarea
                    value={selectedRecord.note ?? ""}
                    onChange={(event) => updateRecord(selectedRecord.id, "note", event.target.value)}
                    className="min-h-28 w-full rounded-2xl border border-slate-200 bg-slate-50 px-3 py-3 text-sm text-slate-900"
                    placeholder="Optional note for this month"
                  />
                </EditField>

                <div className="mt-4 flex gap-3">
                  <button
                    type="button"
                    onClick={() => void saveRecord(selectedRecord)}
                    disabled={savingId === selectedRecord.id || dataSource !== "supabase"}
                    className="rounded-xl bg-slate-900 px-4 py-2 text-sm font-semibold text-white transition hover:bg-slate-800 disabled:cursor-not-allowed disabled:bg-slate-400"
                  >
                    {savingId === selectedRecord.id ? "Saving..." : "Save Changes"}
                  </button>
                  <button
                    type="button"
                    onClick={() => window.print()}
                    className="rounded-xl border border-slate-300 px-4 py-2 text-sm font-semibold text-slate-700 transition hover:bg-slate-50"
                  >
                    Print
                  </button>
                </div>
              </div>
            ) : null}

            {printableSlip ? <SlipPreview slip={printableSlip} /> : null}
          </div>
        </section>
      </div>
    </main>
  );
}

function InfoRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-center justify-between gap-4 rounded-2xl border border-slate-100 bg-slate-50 px-3 py-2">
      <span className="font-medium text-slate-600">{label}</span>
      <span className="font-semibold text-slate-900">{value}</span>
    </div>
  );
}

function EditField({
  label,
  children,
  className = "",
}: {
  label: string;
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <label className={`block ${className}`}>
      <span className="mb-1.5 block text-xs font-semibold uppercase tracking-[0.14em] text-slate-500">
        {label}
      </span>
      {children}
    </label>
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
