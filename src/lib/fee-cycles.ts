const MONTH_NAMES = [
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
] as const;

export type FeeCycleTemplate = {
  monthKey: string;
  label: string;
  dueDate: string;
};

export function buildFeeCyclesForYear(year: number): FeeCycleTemplate[] {
  return MONTH_NAMES.map((monthName, index) => {
    const month = String(index + 1).padStart(2, "0");
    const monthKey = `${year}-${month}-01`;

    return {
      monthKey,
      label: `${monthName} ${year}`,
      dueDate: `${year}-${month}-10`,
    };
  });
}

export function getCurrentBillingContext(date = new Date()) {
  const year = date.getFullYear();
  const monthIndex = date.getMonth();
  const month = String(monthIndex + 1).padStart(2, "0");
  const monthKey = `${year}-${month}-01`;
  const monthName = MONTH_NAMES[monthIndex];

  return {
    year,
    monthIndex,
    monthKey,
    label: `${monthName} ${year}`,
    dueDate: `${year}-${month}-10`,
    cycle: {
      monthKey,
      label: `${monthName} ${year}`,
      dueDate: `${year}-${month}-10`,
    } satisfies FeeCycleTemplate,
  };
}

export function getYearFromMonthKey(monthKey: string) {
  return Number.parseInt(monthKey.slice(0, 4), 10);
}
