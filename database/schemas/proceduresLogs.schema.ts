import { bigserial, timestamp } from "drizzle-orm/pg-core";
import { schema } from "./schema.ts";

export const proceduresLogs = schema.table("procedures_logs", {
  id: bigserial("id", { mode: "number" }).primaryKey().notNull(),
  resultReminder: timestamp("result_reminder", { withTimezone: true }),
  anomalyStatusUpdate: timestamp("anomaly_status_update", {
    withTimezone: true,
  }),
  anomalyFixReminder: timestamp("date_anomaly_fix_reminder", {
    withTimezone: true,
  }),
  indicatorCreationReminder: timestamp("indicator_creation_reminder", {
    withTimezone: true,
  }),
  resultReleaseUpdate: timestamp("result_release_update", {
    withTimezone: true,
  }),
});
