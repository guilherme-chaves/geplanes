import {
  boolean,
  integer,
  text,
  timestamp,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { indicator } from "./indicator.schema.ts";

export const dashboardSyncIndicator = schema.table('dashboard_sync_indicator', {
  indicatorId: integer('indicator_id').notNull().references(() => indicator.id),
  syncDate: timestamp('sync_date', {withTimezone: true}),
  errorCode: integer('error_code'),
  errorMessage: text('error_message'),
  created: boolean('created'),
  deleted: boolean('deleted')
});
