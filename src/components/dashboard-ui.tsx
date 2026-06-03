import type { PaymentStatus } from "@/types/fees";

export const inputClass =
  "w-full rounded-lg border border-slate-200 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none transition placeholder:text-slate-400 focus:border-blue-400 focus:ring-2 focus:ring-blue-100";

export const selectClass =
  "w-full rounded-lg border border-slate-200 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none focus:border-blue-400 focus:ring-2 focus:ring-blue-100";

const btnBase =
  "inline-flex items-center justify-center gap-2 rounded-lg px-4 py-2.5 text-sm font-semibold transition disabled:cursor-not-allowed disabled:opacity-50";

export const btnPrimary = `${btnBase} bg-slate-900 text-white hover:bg-slate-800`;
export const btnSuccess = `${btnBase} bg-emerald-600 text-white hover:bg-emerald-500`;
export const btnAccent = `${btnBase} bg-blue-600 text-white hover:bg-blue-500`;
export const btnOutline = `${btnBase} border border-slate-200 bg-white text-slate-700 hover:bg-slate-50`;
export const btnSoft = `${btnBase} border border-blue-200 bg-blue-50 text-blue-900 hover:bg-blue-100`;

export function Panel({
  children,
  className = "",
}: {
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <section
      className={`rounded-2xl border border-slate-200/80 bg-white shadow-sm ${className}`}
    >
      {children}
    </section>
  );
}

export function StatCard({
  label,
  value,
  hint,
  tone = "neutral",
}: {
  label: string;
  value: string;
  hint?: string;
  tone?: "neutral" | "blue" | "green" | "amber" | "rose";
}) {
  const tones = {
    neutral: "border-slate-200 bg-slate-50 text-slate-900",
    blue: "border-blue-200 bg-blue-50 text-blue-950",
    green: "border-emerald-200 bg-emerald-50 text-emerald-950",
    amber: "border-amber-200 bg-amber-50 text-amber-950",
    rose: "border-rose-200 bg-rose-50 text-rose-950",
  };

  return (
    <div className={`rounded-xl border px-4 py-3 ${tones[tone]}`}>
      <p className="text-xs font-medium uppercase tracking-wide text-slate-500">{label}</p>
      <p className="mt-1 text-xl font-bold tabular-nums">{value}</p>
      {hint ? <p className="mt-0.5 text-xs text-slate-600">{hint}</p> : null}
    </div>
  );
}

export function AlertBanner({
  tone,
  children,
}: {
  tone: "info" | "success" | "warning" | "neutral";
  children: React.ReactNode;
}) {
  const styles = {
    info: "border-blue-200 bg-blue-50 text-blue-950",
    success: "border-emerald-200 bg-emerald-50 text-emerald-950",
    warning: "border-amber-200 bg-amber-50 text-amber-950",
    neutral: "border-slate-200 bg-slate-50 text-slate-700",
  };

  return (
    <div className={`rounded-xl border px-4 py-3 text-sm leading-relaxed ${styles[tone]}`}>
      {children}
    </div>
  );
}

export function FormSection({
  title,
  description,
  children,
}: {
  title: string;
  description?: string;
  children: React.ReactNode;
}) {
  return (
    <div className="rounded-xl border border-slate-100 bg-slate-50/60 p-4">
      <div className="mb-3">
        <h3 className="text-sm font-bold text-slate-900">{title}</h3>
        {description ? <p className="mt-0.5 text-xs text-slate-500">{description}</p> : null}
      </div>
      {children}
    </div>
  );
}

export function EditField({
  label,
  hint,
  children,
  className = "",
}: {
  label: string;
  hint?: string;
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <label className={`block ${className}`}>
      <span className="mb-1 block text-xs font-semibold text-slate-700">{label}</span>
      {children}
      {hint ? <span className="mt-1 block text-xs text-slate-500">{hint}</span> : null}
    </label>
  );
}

export function InfoRow({
  label,
  value,
  highlight = false,
}: {
  label: string;
  value: string;
  highlight?: boolean;
}) {
  return (
    <div
      className={`flex items-center justify-between gap-3 rounded-lg border px-3 py-2.5 ${
        highlight ? "border-slate-300 bg-white" : "border-slate-100 bg-white/80"
      }`}
    >
      <span className="text-sm text-slate-600">{label}</span>
      <span className={`text-sm tabular-nums ${highlight ? "font-bold text-slate-900" : "font-semibold text-slate-900"}`}>
        {value}
      </span>
    </div>
  );
}

export function Money({ amount }: { amount: number }) {
  const formatted = new Intl.NumberFormat("en-PK").format(amount);

  return <span className="tabular-nums font-semibold text-slate-900">Rs. {formatted}</span>;
}

const statusStyles: Record<PaymentStatus, string> = {
  paid: "bg-emerald-100 text-emerald-800 ring-emerald-200",
  partial: "bg-amber-100 text-amber-900 ring-amber-200",
  pending: "bg-rose-100 text-rose-800 ring-rose-200",
};

export function StatusBadge({ status }: { status: PaymentStatus }) {
  return (
    <span
      className={`inline-flex rounded-md px-2.5 py-1 text-xs font-bold capitalize ring-1 ring-inset ${statusStyles[status]}`}
    >
      {status}
    </span>
  );
}

export function ActionGroup({
  label,
  children,
}: {
  label: string;
  children: React.ReactNode;
}) {
  return (
    <div className="flex flex-col gap-2">
      <span className="text-[11px] font-bold uppercase tracking-wider text-slate-400">{label}</span>
      <div className="flex flex-wrap gap-2">{children}</div>
    </div>
  );
}
