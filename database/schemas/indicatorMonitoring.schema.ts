import {
  boolean,
  date,
  index,
  integer,
  numeric,
  serial,
  unique,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { anomaly } from "./anomaly.schema.ts";
import { indicator } from "./indicator.schema.ts";
import { preventiveAction } from "./preventiveAction.schema.ts";

export const indicatorMonitoring = schema.table('indicator_monitoring', {
  id: serial('id').primaryKey().notNull(),
  index: integer('index').notNull(),
  createdAt: date('created_at').notNull(),
  finishedAt: date('finished_at'),
  maxValue: numeric('max_value', {precision: 19, scale: 4}),
  minValue: numeric('min_value', {precision: 19, scale: 4}),
  realValue: numeric('real_value', {precision: 19, scale: 4}),
  baseValueStatus: boolean('base_value_status'),
  realValueStatus: boolean('real_value_status'),
  indicatorId: integer('indicator_id').notNull().references(() => indicator.id, {onDelete: 'cascade'}),
  anomalyId: integer('anomaly_id').references(() => anomaly.id),
  resultReminderDate: date('result_reminder_date'),
  preventiveActionId: integer('preventive_action_id').references(() => preventiveAction.id),
  notApplicable: boolean('not_applicable'),
},
  (t) => [{
    indicatorMonitoringUk: unique('indicator_monitoring_uk').on(t.indicatorId, t.index, t.createdAt, t.finishedAt),
    indicatorIdx: index('indicator_idx').using('btree', t.indicatorId),
    anomalyIdx: index('anomaly_idx').using('btree', t.anomalyId),
    preventiveActionIdx: index('preventive_actio_idx').using('btree', t.preventiveActionId)
  }]
);
