import { schema } from "./schema.ts";

import {
  date,
  index,
  integer,
  serial,
  text,
} from 'drizzle-orm/pg-core';
import { anomaly } from "./anomaly.schema.ts";
import { initiative } from "./initiative.schema.ts";
import { managementUnit } from "./managementUnit.schema.ts";
import { preventiveAction } from "./preventiveAction.schema.ts";
import { users } from "./users.schema.ts";

export const actionPlan = schema.table('action_plan', {
  id: serial('id').primaryKey().notNull(),
  description: text('description').notNull(),
  descriptionHow: text('description_how'),
  descriptionWhy: text('description_why'),
  descriptionWho: text('description_who'),
  anomalyId: integer('anomaly_id').references(() => anomaly.id, {onDelete: 'cascade'}),
  planDate: date('plan_date'),
  status: integer('status'), // TODO
  statusUpdateDate: date('status_update_date'),
  preventiveActionId: integer('preventive_action_id').references(() => preventiveAction.id, {onDelete: 'cascade'}),
  managementUnitId: integer('management_unit_id').notNull().references(() => managementUnit.id),
  initiativeId: integer('initiative_id').references(() => initiative.id, {onDelete: 'cascade'}),
  userId: integer('user_id').references(() => users.id),
  amountP: integer('amount_p'),
  amountR: integer('amount_r'),
  measurementDescription: text(),
},
  (t) => [{
    anomalyIdx: index('anomaly_idx').using('btree', t.anomalyId),
    preventiveActionIdx: index('preventive_action_idx').using('btree', t.preventiveActionId),
    managementUnitIdx: index('management_unit_idx').using('btree', t.managementUnitId),
    initiativeIdx: index('initiative_idx').using('btree', t.initiativeId),
    userIdx: index('user_idx').using('btree', t.userId),
  }]
);
