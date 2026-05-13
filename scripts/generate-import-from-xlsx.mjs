import fs from "node:fs";
import path from "node:path";
import XLSX from "xlsx";

const workspaceRoot = process.cwd();
const inputPath =
  process.argv[2] ?? "/Users/wsquare/Downloads/Styled_March_Fee_2023.xlsx";
const outputJsonPath = process.argv[3] ?? path.join(workspaceRoot, "src/lib/imported-fees.json");
const outputSqlPath = process.argv[4] ?? path.join(workspaceRoot, "supabase/import_xlsx_seed.sql");

const MONTHS = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

function normalizeWhitespace(value) {
  return String(value ?? "")
    .replace(/\s+/g, " ")
    .replace(/\u0656/g, "")
    .trim();
}

function parseAmount(value) {
  if (typeof value === "number" && Number.isFinite(value)) {
    return value;
  }

  const normalized = normalizeWhitespace(value).replace(/,/g, "");

  if (!normalized) {
    return 0;
  }

  const parsed = Number(normalized);
  return Number.isFinite(parsed) ? parsed : 0;
}

function padNumber(value, width = 4) {
  return String(value).padStart(width, "0");
}

function escapeSql(value) {
  return String(value).replace(/'/g, "''");
}

function inferCycleInfo(filePath) {
  const baseName = path.basename(filePath);
  const match = baseName.match(
    /(january|february|march|april|may|june|july|august|september|october|november|december)[^0-9]*(\d{4})/i,
  );

  if (!match) {
    throw new Error(
      `Could not infer billing month/year from file name: ${baseName}. Rename the file to include something like March_2023.`,
    );
  }

  const monthLabel = MONTHS.find(
    (month) => month.toLowerCase() === match[1].toLowerCase(),
  );

  if (!monthLabel) {
    throw new Error(`Unsupported month label in file name: ${match[1]}`);
  }

  const monthIndex = MONTHS.indexOf(monthLabel) + 1;
  const year = Number(match[2]);

  return {
    label: `${monthLabel} ${year}`,
    monthKey: `${year}-${String(monthIndex).padStart(2, "0")}-01`,
    dueDate: `${year}-${String(monthIndex).padStart(2, "0")}-10`,
    monthName: monthLabel,
    year,
  };
}

function splitStudents(value) {
  return normalizeWhitespace(value)
    .split(",")
    .map((student) => normalizeWhitespace(student.replace(/\.+/g, ".")))
    .filter(Boolean);
}

function extractStudentShape(studentName) {
  const match = studentName.match(/^(.*?)(?:\(([^)]+)\))?$/);
  const name = normalizeWhitespace(match?.[1] ?? studentName);
  const className = normalizeWhitespace(match?.[2] ?? "");

  return {
    studentName: name,
    className: className || null,
  };
}

function distributeFeeAcrossStudents(totalFee, students) {
  if (students.length === 0) {
    return [];
  }

  const baseShare = Math.floor((totalFee / students.length) * 100) / 100;
  let allocated = 0;

  return students.map((student, index) => {
    const isLast = index === students.length - 1;
    const monthlyFee = isLast
      ? Number((totalFee - allocated).toFixed(2))
      : Number(baseShare.toFixed(2));

    allocated = Number((allocated + monthlyFee).toFixed(2));

    return {
      ...student,
      monthlyFee,
    };
  });
}

function buildImportRecord(row) {
  const familyNumber = normalizeWhitespace(row["Family No"]);
  const students = splitStudents(row["Students Names of Family"]);
  const fatherName = normalizeWhitespace(row["Father Name"]);
  const rawMonthLabel = normalizeWhitespace(row["Month of Fee"]) || "March";
  const tuitionFee = parseAmount(row["Fee"]);
  const otherCharges = parseAmount(row["Other"]);
  const rawTotalAmount = parseAmount(row["Total Amount"]);
  const amountReceived = parseAmount(row["Obtained "]);
  const rawArrears = parseAmount(row["Arrears"]);
  const totalDue = Math.max(rawTotalAmount, tuitionFee + otherCharges, amountReceived + rawArrears);
  const carriedForward = Math.max(totalDue - tuitionFee - otherCharges, 0);
  const arrears = Math.max(rawArrears, totalDue - amountReceived, 0);

  return {
    familyNumber,
    students,
    fatherName,
    rawMonthLabel,
    tuitionFee,
    otherCharges,
    rawTotalAmount,
    carriedForward,
    totalDue,
    amountReceived,
    arrears,
  };
}

function toDashboardRecord(record, cycleInfo, index) {
  return {
    id: `family-${padNumber(index + 1)}`,
    familyNumber: record.familyNumber || "-",
    familyCode: `EGSS-FAM-${padNumber(index + 1)}`,
    students: record.students,
    fatherName: record.fatherName,
    phone: "",
    monthLabel: cycleInfo.label,
    tuitionFee: record.tuitionFee,
    otherCharges: record.otherCharges,
    carriedForward: record.carriedForward,
    amountReceived: record.amountReceived,
    dueDate: cycleInfo.dueDate,
    importNote:
      record.rawMonthLabel && record.rawMonthLabel !== cycleInfo.monthName
        ? `Imported from row month label: ${record.rawMonthLabel}`
        : "",
  };
}

function buildSql(dataset) {
  const lines = [];

  lines.push("-- One-time import generated from Styled_March_Fee_2023.xlsx");
  lines.push("-- Paste into the Supabase SQL Editor and run once.");
  lines.push("begin;");
  lines.push("");
  lines.push(
    `insert into public.fee_cycles (month_key, label, due_date, status)
values (date '${dataset.billingCycle.monthKey}', '${escapeSql(dataset.billingCycle.label)}', date '${dataset.billingCycle.dueDate}', 'open')
on conflict (month_key) do update
set label = excluded.label,
    due_date = excluded.due_date;`,
  );
  lines.push("");

  dataset.records.forEach((record, index) => {
    const familyCode = `EGSS-FAM-${padNumber(index + 1)}`;
    const familyComment = `${record.fatherName || "Unknown Guardian"} / ${record.familyNumber || "No Family No"}`;
    const normalizedStudents = distributeFeeAcrossStudents(
      record.tuitionFee,
      record.students.map(extractStudentShape),
    );
    const noteParts = [];

    if (record.rawMonthLabel && record.rawMonthLabel !== dataset.billingCycle.monthName) {
      noteParts.push(`Imported Month of Fee: ${record.rawMonthLabel}`);
    }

    if (record.rawTotalAmount && record.rawTotalAmount !== record.totalDue) {
      noteParts.push(`Sheet Total Amount: ${record.rawTotalAmount}`);
    }

    const note = noteParts.join(" | ");

    lines.push(`-- ${escapeSql(familyComment)}`);
    lines.push(
      `with upsert_family as (
  insert into public.families (family_code, legacy_family_number, guardian_name, phone, address, is_active)
  values ('${familyCode}', '${escapeSql(record.familyNumber)}', '${escapeSql(record.fatherName)}', null, null, true)
  on conflict (family_code) do update
  set legacy_family_number = excluded.legacy_family_number,
      guardian_name = excluded.guardian_name,
      is_active = excluded.is_active
  returning id
), selected_family as (
  select id from upsert_family
  union all
  select id from public.families where family_code = '${familyCode}' limit 1
), selected_cycle as (
  select id from public.fee_cycles where month_key = date '${dataset.billingCycle.monthKey}'
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
  ${record.tuitionFee.toFixed(2)},
  ${record.otherCharges.toFixed(2)},
  ${record.carriedForward.toFixed(2)},
  ${record.totalDue.toFixed(2)},
  ${record.amountReceived.toFixed(2)},
  ${record.arrears.toFixed(2)},
  ${note ? `'${escapeSql(note)}'` : "null"}
from selected_family
cross join selected_cycle
on conflict (family_id, fee_cycle_id) do update
set tuition_amount = excluded.tuition_amount,
    other_charges = excluded.other_charges,
    carry_forward_amount = excluded.carry_forward_amount,
    total_due = excluded.total_due,
    amount_received = excluded.amount_received,
    arrears_amount = excluded.arrears_amount,
    note = excluded.note;`,
    );

    normalizedStudents.forEach((student) => {
      lines.push(
        `insert into public.students (family_id, student_name, class_name, monthly_fee, is_active)
select id, '${escapeSql(student.studentName)}', ${
          student.className ? `'${escapeSql(student.className)}'` : "null"
        }, ${student.monthlyFee.toFixed(2)}, true
from public.families
where family_code = '${familyCode}';`,
      );
    });

    if (record.amountReceived > 0) {
      lines.push(
        `insert into public.payments (monthly_fee_record_id, amount, payment_date, payment_method, note)
select mfr.id, ${record.amountReceived.toFixed(2)}, date '${dataset.billingCycle.dueDate}', 'xlsx-import', 'Imported opening payment from workbook'
from public.monthly_fee_records mfr
join public.families f on f.id = mfr.family_id
join public.fee_cycles fc on fc.id = mfr.fee_cycle_id
where f.family_code = '${familyCode}'
  and fc.month_key = date '${dataset.billingCycle.monthKey}';`,
      );
    }

    lines.push("");
  });

  lines.push("commit;");
  lines.push("");

  return lines.join("\n");
}

const workbook = XLSX.readFile(inputPath);
const sheet = workbook.Sheets[workbook.SheetNames[0]];
const rawRows = XLSX.utils.sheet_to_json(sheet, { defval: "" });
const cycleInfo = inferCycleInfo(inputPath);

const records = rawRows
  .map(buildImportRecord)
  .filter((record) => record.familyNumber || record.fatherName || record.students.length > 0);

const dashboardRecords = records.map((record, index) => toDashboardRecord(record, cycleInfo, index));

const dataset = {
  schoolName: "Eden Grammar School System",
  sourceFile: path.basename(inputPath),
  importedAt: new Date().toISOString(),
  billingCycle: cycleInfo,
  rawMonthLabels: [...new Set(records.map((record) => record.rawMonthLabel).filter(Boolean))],
  records,
  dashboardRecords,
};

fs.writeFileSync(outputJsonPath, `${JSON.stringify(dataset, null, 2)}\n`);
fs.writeFileSync(outputSqlPath, `${buildSql(dataset)}\n`);

console.log(`Imported ${records.length} rows from ${path.basename(inputPath)}`);
console.log(`JSON written to ${outputJsonPath}`);
console.log(`SQL written to ${outputSqlPath}`);
