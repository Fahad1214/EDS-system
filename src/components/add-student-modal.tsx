"use client";

import { useMemo, useState } from "react";
import {
  btnOutline,
  btnSuccess,
  FormSection,
  inputClass,
  selectClass,
} from "@/components/dashboard-ui";
import { Modal } from "@/components/ui/modal";
import { getArrears, getTotalDue } from "@/lib/fee-math";
import { getSupabaseBrowserClient } from "@/lib/supabase/client";
import type { DashboardFamilyRecord } from "@/types/fees";

const supabase = getSupabaseBrowserClient();

type FamilyRow = {
  id: string;
  family_code: string;
  legacy_family_number: string | null;
  guardian_name: string;
  phone: string | null;
};

type SupabaseWriteResult<T> = {
  data: T | null;
  error: { message: string } | null;
};

type FeeCycleOption = {
  id: string;
  monthKey: string;
  label: string;
  dueDate: string;
};

type ExistingFamilyOption = {
  familyId: string;
  familyNumber: string;
  familyCode: string;
  fatherName: string;
  phone: string;
};

type AddStudentModalProps = {
  open: boolean;
  feeCycles: FeeCycleOption[];
  existingFamilies: ExistingFamilyOption[];
  nextFamilyCode: string;
  defaultFeeCycleId?: string;
  onClose: () => void;
  onCreated: (record: DashboardFamilyRecord) => void;
};

const fieldClass = `${inputClass} mt-1`;

function FormField({
  label,
  required,
  children,
  className = "",
}: {
  label: string;
  required?: boolean;
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <label className={`block text-sm font-medium text-slate-700 ${className}`}>
      {label}
      {required ? <span className="text-rose-600"> *</span> : null}
      {children}
    </label>
  );
}

export function AddStudentModal({
  open,
  feeCycles,
  existingFamilies,
  nextFamilyCode,
  defaultFeeCycleId,
  onClose,
  onCreated,
}: AddStudentModalProps) {
  const [mode, setMode] = useState<"new" | "existing">("new");
  const [feeCycleId, setFeeCycleId] = useState(defaultFeeCycleId ?? feeCycles[0]?.id ?? "");
  const [existingFamilyId, setExistingFamilyId] = useState(existingFamilies[0]?.familyId ?? "");

  const [familyNumber, setFamilyNumber] = useState("");
  const [guardianName, setGuardianName] = useState("");
  const [phone, setPhone] = useState("");
  const [address, setAddress] = useState("");

  const [studentName, setStudentName] = useState("");
  const [className, setClassName] = useState("");
  const [monthlyFee, setMonthlyFee] = useState(0);

  const [tuitionFee, setTuitionFee] = useState(0);
  const [annualFund, setAnnualFund] = useState(0);
  const [otherCharges, setOtherCharges] = useState(0);
  const [carriedForward, setCarriedForward] = useState(0);
  const [amountReceived, setAmountReceived] = useState(0);
  const [note, setNote] = useState("");

  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");

  const selectedCycle = feeCycles.find((cycle) => cycle.id === feeCycleId) ?? feeCycles[0];
  const selectedExistingFamily = existingFamilies.find((family) => family.familyId === existingFamilyId);

  const feeDraft = useMemo(
    () => ({
      tuitionFee: mode === "new" ? tuitionFee : monthlyFee,
      otherCharges,
      annualFund,
      carriedForward,
      amountReceived,
    }),
    [mode, tuitionFee, monthlyFee, otherCharges, annualFund, carriedForward, amountReceived],
  );

  function resetForm() {
    setMode("new");
    setFamilyNumber("");
    setGuardianName("");
    setPhone("");
    setAddress("");
    setStudentName("");
    setClassName("");
    setMonthlyFee(0);
    setTuitionFee(0);
    setAnnualFund(0);
    setOtherCharges(0);
    setCarriedForward(0);
    setAmountReceived(0);
    setNote("");
    setError("");
  }

  function handleClose() {
    resetForm();
    onClose();
  }

  async function handleSubmit(event: React.FormEvent) {
    event.preventDefault();
    setError("");

    if (!studentName.trim()) {
      setError("Student name is required.");
      return;
    }

    if (!selectedCycle) {
      setError("Select a fee month.");
      return;
    }

    if (mode === "new" && !guardianName.trim()) {
      setError("Guardian name is required for a new family.");
      return;
    }

    if (mode === "existing" && !selectedExistingFamily) {
      setError("Select an existing family.");
      return;
    }

    setSaving(true);

    const totalDue = getTotalDue(feeDraft);
    const arrears = getArrears(feeDraft);

    try {
      let family: FamilyRow;

      if (mode === "new") {
        const familyInsert = (await supabase
          .from("families")
          .insert({
            family_code: nextFamilyCode,
            legacy_family_number: familyNumber.trim() || null,
            guardian_name: guardianName.trim(),
            phone: phone.trim() || null,
            address: address.trim() || null,
            is_active: true,
          } as never)
          .select("id, family_code, legacy_family_number, guardian_name, phone")
          .single()) as SupabaseWriteResult<FamilyRow>;

        if (familyInsert.error || !familyInsert.data) {
          throw new Error(familyInsert.error?.message ?? "Could not create family.");
        }

        family = familyInsert.data;
      } else {
        const familyFetch = (await supabase
          .from("families")
          .select("id, family_code, legacy_family_number, guardian_name, phone")
          .eq("id", existingFamilyId)
          .single()) as SupabaseWriteResult<FamilyRow>;

        if (familyFetch.error || !familyFetch.data) {
          throw new Error(familyFetch.error?.message ?? "Could not load family.");
        }

        family = familyFetch.data;
      }

      const studentInsert = await supabase.from("students").insert({
        family_id: family.id,
        student_name: studentName.trim(),
        class_name: className.trim() || null,
        monthly_fee: mode === "new" ? tuitionFee : monthlyFee,
        is_active: true,
      } as never);

      if (studentInsert.error) {
        throw new Error(studentInsert.error.message);
      }

      if (mode === "existing") {
        const existingRecord = (await supabase
          .from("monthly_fee_records")
          .select("id, tuition_amount, other_charges, annual_fund_amount, carry_forward_amount")
          .eq("family_id", family.id)
          .eq("fee_cycle_id", selectedCycle.id)
          .maybeSingle()) as SupabaseWriteResult<{
          id: string;
          tuition_amount: number;
          other_charges: number;
          annual_fund_amount: number;
          carry_forward_amount: number;
        }>;

        if (existingRecord.error) {
          throw new Error(existingRecord.error.message);
        }

        if (existingRecord.data) {
          const row = existingRecord.data;

          const updatedTuition = Number(row.tuition_amount) + monthlyFee;
          const updatedDraft = {
            tuitionFee: updatedTuition,
            otherCharges: Number(row.other_charges) + otherCharges,
            annualFund: Number(row.annual_fund_amount) + annualFund,
            carriedForward: Number(row.carry_forward_amount),
            amountReceived,
          };
          const updatedTotal = getTotalDue(updatedDraft);
          const updatedArrears = getArrears(updatedDraft);

          const monthlyUpdate = await supabase
            .from("monthly_fee_records")
            .update({
              tuition_amount: updatedTuition,
              other_charges: updatedDraft.otherCharges,
              annual_fund_amount: updatedDraft.annualFund,
              total_due: updatedTotal,
              arrears_amount: updatedArrears,
              note: note.trim() || null,
            } as never)
            .eq("id", row.id);

          if (monthlyUpdate.error) {
            throw new Error(monthlyUpdate.error.message);
          }

          if (amountReceived > 0) {
            await supabase.from("payments").delete().eq("monthly_fee_record_id", row.id);
            const paymentInsert = await supabase.from("payments").insert({
              monthly_fee_record_id: row.id,
              amount: amountReceived,
              payment_date: new Date().toISOString().slice(0, 10),
              payment_method: "dashboard-add-student",
              note: "Updated when adding student",
            } as never);

            if (paymentInsert.error) {
              throw new Error(paymentInsert.error.message);
            }
          }

          const studentsFetch = await supabase
            .from("students")
            .select("student_name, class_name")
            .eq("family_id", family.id)
            .eq("is_active", true);

          const studentNames = (studentsFetch.data ?? []).map(
            (student) => (student as { student_name: string }).student_name,
          );
          const classNames = (studentsFetch.data ?? [])
            .map((student) => (student as { class_name: string | null }).class_name ?? "")
            .filter(Boolean);

          onCreated({
            id: row.id,
            familyId: family.id,
            feeCycleId: selectedCycle.id,
            familyNumber: family.legacy_family_number ?? selectedExistingFamily?.familyNumber ?? "",
            familyCode: family.family_code,
            students: studentNames,
            classNames,
            fatherName: family.guardian_name,
            phone: family.phone ?? "",
            monthLabel: selectedCycle.label,
            monthKey: selectedCycle.monthKey,
            tuitionFee: updatedTuition,
            otherCharges: updatedDraft.otherCharges,
            annualFund: updatedDraft.annualFund,
            carriedForward: updatedDraft.carriedForward,
            amountReceived,
            dueDate: selectedCycle.dueDate,
            note: note.trim(),
          });
          handleClose();
          return;
        }
      }

      const monthlyInsert = (await supabase
        .from("monthly_fee_records")
        .insert({
          family_id: family.id,
          fee_cycle_id: selectedCycle.id,
          tuition_amount: feeDraft.tuitionFee,
          other_charges: otherCharges,
          annual_fund_amount: annualFund,
          carry_forward_amount: carriedForward,
          total_due: totalDue,
          amount_received: 0,
          arrears_amount: arrears,
          note: note.trim() || null,
        } as never)
        .select("id")
        .single()) as SupabaseWriteResult<{ id: string }>;

      if (monthlyInsert.error || !monthlyInsert.data) {
        throw new Error(monthlyInsert.error?.message ?? "Could not create monthly fee record.");
      }

      const monthlyRecord = monthlyInsert.data;

      if (amountReceived > 0) {
        const paymentInsert = await supabase.from("payments").insert({
          monthly_fee_record_id: monthlyRecord.id,
          amount: amountReceived,
          payment_date: new Date().toISOString().slice(0, 10),
          payment_method: "dashboard-add-student",
          note: "Initial payment on student registration",
        } as never);

        if (paymentInsert.error) {
          throw new Error(paymentInsert.error.message);
        }
      }

      onCreated({
        id: monthlyRecord.id,
        familyId: family.id,
        feeCycleId: selectedCycle.id,
        familyNumber: family.legacy_family_number ?? familyNumber.trim(),
        familyCode: family.family_code,
        students: [studentName.trim()],
        classNames: className.trim() ? [className.trim()] : [],
        fatherName: family.guardian_name,
        phone: family.phone ?? "",
        monthLabel: selectedCycle.label,
        monthKey: selectedCycle.monthKey,
        tuitionFee: feeDraft.tuitionFee,
        otherCharges,
        annualFund,
        carriedForward,
        amountReceived,
        dueDate: selectedCycle.dueDate,
        note: note.trim(),
      });

      handleClose();
    } catch (submitError) {
      setError(submitError instanceof Error ? submitError.message : "Could not save student.");
    } finally {
      setSaving(false);
    }
  }

  return (
    <Modal
      open={open}
      title="Add Student"
      description="Register a new student with family and fee details."
      onClose={handleClose}
    >
      <form onSubmit={(event) => void handleSubmit(event)} className="space-y-6">
        <div className="flex flex-wrap gap-2">
          <button
            type="button"
            onClick={() => setMode("new")}
            className={`rounded-full px-4 py-1.5 text-sm font-semibold transition ${
              mode === "new"
                ? "bg-slate-900 text-white"
                : "bg-slate-100 text-slate-700 hover:bg-slate-200"
            }`}
          >
            New Family
          </button>
          <button
            type="button"
            onClick={() => setMode("existing")}
            disabled={existingFamilies.length === 0}
            className={`rounded-full px-4 py-1.5 text-sm font-semibold transition disabled:cursor-not-allowed disabled:opacity-50 ${
              mode === "existing"
                ? "bg-slate-900 text-white"
                : "bg-slate-100 text-slate-700 hover:bg-slate-200"
            }`}
          >
            Existing Family
          </button>
        </div>

        <fieldset className="space-y-3 rounded-2xl border border-slate-100 bg-slate-50/80 p-4">
          <legend className="px-1 text-xs font-bold uppercase tracking-[0.14em] text-slate-500">
            Family Details
          </legend>

          {mode === "existing" ? (
            <FormField label="Family" required className="col-span-full">
              <select
                value={existingFamilyId}
                onChange={(event) => setExistingFamilyId(event.target.value)}
                className={fieldClass}
              >
                {existingFamilies.map((family) => (
                  <option key={family.familyId} value={family.familyId}>
                    #{family.familyNumber || "-"} — {family.fatherName} ({family.familyCode})
                  </option>
                ))}
              </select>
            </FormField>
          ) : (
            <div className="grid gap-3 sm:grid-cols-2">
              <FormField label="Family ID / Family No" required>
                <input
                  value={familyNumber}
                  onChange={(event) => setFamilyNumber(event.target.value)}
                  placeholder="e.g. 118"
                  className={fieldClass}
                />
              </FormField>
              <FormField label="Family Code">
                <input value={nextFamilyCode} readOnly className={`${fieldClass} bg-slate-100`} />
              </FormField>
              <FormField label="Guardian / Father Name" required className="sm:col-span-2">
                <input
                  value={guardianName}
                  onChange={(event) => setGuardianName(event.target.value)}
                  className={fieldClass}
                />
              </FormField>
              <FormField label="Phone">
                <input
                  value={phone}
                  onChange={(event) => setPhone(event.target.value)}
                  className={fieldClass}
                />
              </FormField>
              <FormField label="Address">
                <input
                  value={address}
                  onChange={(event) => setAddress(event.target.value)}
                  className={fieldClass}
                />
              </FormField>
            </div>
          )}
        </fieldset>

        <fieldset className="space-y-3 rounded-2xl border border-slate-100 bg-slate-50/80 p-4">
          <legend className="px-1 text-xs font-bold uppercase tracking-[0.14em] text-slate-500">
            Student Details
          </legend>
          <div className="grid gap-3 sm:grid-cols-2">
            <FormField label="Student Name" required>
              <input
                value={studentName}
                onChange={(event) => setStudentName(event.target.value)}
                className={fieldClass}
              />
            </FormField>
            <FormField label="Class">
              <input
                value={className}
                onChange={(event) => setClassName(event.target.value)}
                placeholder="e.g. Grade 5"
                className={fieldClass}
              />
            </FormField>
            {mode === "existing" ? (
              <FormField label="Monthly Fee (this student)">
                <input
                  type="number"
                  min={0}
                  value={monthlyFee}
                  onChange={(event) => setMonthlyFee(Number(event.target.value || 0))}
                  className={fieldClass}
                />
              </FormField>
            ) : null}
          </div>
        </fieldset>

        <fieldset className="space-y-3 rounded-2xl border border-slate-100 bg-slate-50/80 p-4">
          <legend className="px-1 text-xs font-bold uppercase tracking-[0.14em] text-slate-500">
            Fee Details
          </legend>
          <div className="grid gap-3 sm:grid-cols-2">
            <FormField label="Fee Month" required className="sm:col-span-2">
              <select
                value={feeCycleId}
                onChange={(event) => setFeeCycleId(event.target.value)}
                className={fieldClass}
              >
                {feeCycles.map((cycle) => (
                  <option key={cycle.id} value={cycle.id}>
                    {cycle.label}
                  </option>
                ))}
              </select>
            </FormField>
            {mode === "new" ? (
              <FormField label="Monthly Fee (Tuition)">
                <input
                  type="number"
                  min={0}
                  value={tuitionFee}
                  onChange={(event) => setTuitionFee(Number(event.target.value || 0))}
                  className={fieldClass}
                />
              </FormField>
            ) : null}
            <FormField label="Annual Fund">
              <input
                type="number"
                min={0}
                value={annualFund}
                onChange={(event) => setAnnualFund(Number(event.target.value || 0))}
                className={fieldClass}
              />
            </FormField>
            <FormField label="Other Charges">
              <input
                type="number"
                min={0}
                value={otherCharges}
                onChange={(event) => setOtherCharges(Number(event.target.value || 0))}
                className={fieldClass}
              />
            </FormField>
            <FormField label="Pending Previous">
              <input
                type="number"
                min={0}
                value={carriedForward}
                onChange={(event) => setCarriedForward(Number(event.target.value || 0))}
                className={fieldClass}
              />
            </FormField>
            <FormField label="Received">
              <input
                type="number"
                min={0}
                value={amountReceived}
                onChange={(event) => setAmountReceived(Number(event.target.value || 0))}
                className={fieldClass}
              />
            </FormField>
            <FormField label="Note" className="sm:col-span-2">
              <textarea
                value={note}
                onChange={(event) => setNote(event.target.value)}
                rows={2}
                className={fieldClass}
              />
            </FormField>
          </div>
          <p className="text-sm text-slate-600">
            Total due:{" "}
            <strong className="text-slate-900">
              Rs. {getTotalDue(feeDraft).toLocaleString("en-PK")}
            </strong>
          </p>
        </fieldset>

        {error ? (
          <p className="rounded-xl border border-rose-200 bg-rose-50 px-3 py-2 text-sm text-rose-800">
            {error}
          </p>
        ) : null}

        <div className="flex flex-wrap gap-3 border-t border-slate-100 pt-4">
          <button
            type="submit"
            disabled={saving || feeCycles.length === 0}
            className="rounded-xl bg-emerald-700 px-5 py-2.5 text-sm font-semibold text-white hover:bg-emerald-600 disabled:cursor-not-allowed disabled:bg-slate-400"
          >
            {saving ? "Saving..." : "Save Student"}
          </button>
          <button
            type="button"
            onClick={handleClose}
            className="rounded-xl border border-slate-300 px-5 py-2.5 text-sm font-semibold text-slate-700 hover:bg-slate-50"
          >
            Cancel
          </button>
        </div>
      </form>
    </Modal>
  );
}
