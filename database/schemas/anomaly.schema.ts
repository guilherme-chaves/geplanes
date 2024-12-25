import {
  bigint,
  boolean,
  date,
  foreignKey,
  index,
  integer,
  serial,
  text,
  varchar,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { internalAuditItem } from "./internalAuditItem.schema.ts";
import { managementUnit } from "./managementUnit.schema.ts";
import { occurrence } from "./occurrence.schema.ts";
import { users } from "./users.schema.ts";

export const anomaly = schema.table('anomaly', {
  id: serial('id').primaryKey().notNull(),
  conclusion: text('conclusion'),
  createdAt: date('created_at').notNull(),
  finishedAt: date('finished_at'),
  description: text('description'),
  location: integer('location').notNull(),
  immediateCounterMeasures: text('immediate_counter_measures'),
  mUnitResponsibleId: integer('m_unit_responsible_id').notNull().references(() => managementUnit.id),
  mUnitRecordId: integer('m_unit_record_id').notNull().references(() => managementUnit.id),
  observations: text('observations'),
  classification: integer('classification'),
  personInCharge: integer('person_in_charge').notNull().references(() => users.id),
  verificationDesc: text('verification'),
  standardizationDesc: text('standardization'),
  occurrenceId: integer('occurrence_id').references(() => occurrence.id),
  anomalySourceDesc: text('anomaly_source_desc'),
  unlockedAt: date('unlocked_at'),
  reminderSent: boolean('reminded_sent'),
  status: integer('status').notNull(), // TODO
  statusProcessing: integer('status_processing'), // TODO
  type: integer(), // TODO
  anomalySource: integer('anomaly_source'),
  closureRequestedAt: date('closure_requested_at'),
  subordinationId: integer('subordination_id'),
  auditType: varchar('audit_type', {length: 255}), // TODO
  internalAuditItemId: bigint('internal_audit_item_id', {mode: 'number'}).references(() => internalAuditItem.id),
},
  (t) => [{
    subordinationFk: foreignKey({
      columns: [t.subordinationId],
      foreignColumns: [t.id],
      name: 'anomaly_subordination_id_fk',
    }).onDelete('cascade'),
    mUnitRecordIdx: index('m_unit_record_idx').using('btree', t.mUnitRecordId),
    internalAuditItemIdx: index('internal_audit_item_idx').using('btree', t.internalAuditItemId),
    occurrenceIdx: index('occurrence_idx').using('btree', t.occurrenceId),
    subordinationIdx: index('subordination_idx').using('btree', t.subordinationId),
    mUnitResponsibleIdx: index('m_unit_responsible_idx').using('btree', t.mUnitResponsibleId),
  }]
);
