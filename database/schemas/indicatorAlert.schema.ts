import {
  integer,
  serial,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { dashboardSyncIndicator } from "./dashboardSyncIndicator.schema.ts";
import { indicatorMonitoring } from "./indicatorMonitoring.schema.ts";

export const indicatorAlert = schema.table('indicator_alert', {
  id: serial('id').primaryKey().notNull(),
  indicatorMonitoringId: integer('indicator_monitoring_id').references(() => indicatorMonitoring.id, {onDelete: 'set null'}),
  alertId: integer('alert_id'), // TODO
  indicatorId: integer('indicator_id').references(() => dashboardSyncIndicator.indicatorId),
});
