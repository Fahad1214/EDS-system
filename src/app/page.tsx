import { FeeDashboard } from "@/components/fee-dashboard";
import { getDashboardData } from "@/lib/dashboard-data";

export const dynamic = "force-dynamic";

export default async function Home() {
  const { records, feeCycles, source } = await getDashboardData();

  return (
    <FeeDashboard
      initialRecords={records}
      initialFeeCycles={feeCycles}
      schoolName="Eden Grammar School System"
      dataSource={source}
    />
  );
}
