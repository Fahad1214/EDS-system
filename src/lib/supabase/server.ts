import { createClient } from "@supabase/supabase-js";
import { getSupabaseEnv } from "@/lib/env";

export function getSupabaseServerClient() {
  const { url, anonKey } = getSupabaseEnv();

  return createClient(url, anonKey, {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
    },
  });
}
