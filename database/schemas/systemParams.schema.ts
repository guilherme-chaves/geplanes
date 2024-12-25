import {
  boolean,
  index,
  integer,
  serial,
  uuid,
  varchar,
} from "drizzle-orm/pg-core";
import { bytea, schema } from "./schema.ts";
import { files } from "./files.schema.ts";

export const systemParams = schema.table("system_params", {
  id: serial("id").primaryKey().notNull(),
  smtpServer: varchar("smtp_server", { length: 160 }).notNull(),
  smtpPort: integer("smtp_port").notNull(),
  smtpAuthRequired: boolean("smtp_auth_required").notNull(),
  smtpSslRequired: boolean("smtp_ssl_required").notNull(),
  smtpUser: varchar("smtp_user", { length: 160 }).notNull(),
  smtpPassword: bytea("smtp_password"),
  smtpSender: varchar("smtp_sender", { length: 160 }).notNull(),
  logoId: uuid("logo_id").references(() => files.id, { onDelete: "set null" }),
  reportLogoId: uuid("report_logo_id").references(() => files.id, {
    onDelete: "set null",
  }),
  notifyInvolvedUsersAnomaly: boolean("notify_involved_users_anomaly")
    .notNull(),
  timerCreateIndicatorTarget: integer("timer_create_indicator_target")
    .notNull(),
  timerRealValuesUpdate: integer("timer_real_values_update").notNull(),
  timerAnomalyFixReminder: integer("timeranomaly_fix_reminder").notNull(),
  timerAnomalyFixLock: integer("timeranomaly_fix_lock").notNull(),
  timerAnomalyFixClosure: integer("timeranomaly_fix_closure").notNull(),
}, (t) => [{
  logoIdx: index("logo_idx").using("btree", t.logoId),
  reportLogoIdx: index("report_logo_idx").using("btree", t.reportLogoId),
}]);
