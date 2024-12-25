import {
  boolean,
  date,
  index,
  integer,
  serial,
  text,
  varchar,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { managementUnit } from "./managementUnit.schema.ts";
import { users } from "./users.schema.ts";

export const occurrence = schema.table('occurrence', {
  id: serial('id').primaryKey().notNull(),
  description: text('description'),
  occurrenceDate: date('occurrence_date').notNull(),
  status: varchar('status', {length: 160}),
  managementUnitId: integer('management_unit_id').notNull().references(() => managementUnit.id, {onDelete: 'cascade'}),
  reporterId: integer('reporter_id').references(() => users.id),
  repeatedIncident: boolean('repeated_incident'),
  immediateCountermeasures: text('immediate_countermeasures'),
  number: integer('number').notNull(), // TODO
},
  (t) => [{
    managementUnitIdx: index('management_unit_idx').using('btree', t.managementUnitId),
    reporterIdx: index('reporter_idx').using('btree', t.reporterId),
  }]
);