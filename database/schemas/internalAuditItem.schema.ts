import {
  bigserial,
  index,
  integer,
  text,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { internalAudit } from "./internalAudit.schema.ts";
import { managementUnit } from "./managementUnit.schema.ts";
import { normRequirement } from "./normRequirement.schema.ts";

export const internalAuditItem = schema.table('internal_audit_item', {
  id: bigserial('id', {mode: 'number'}).primaryKey().notNull(),
  internalAuditId: integer('internal_audit_id').notNull().references(() => internalAudit.id, {onDelete: 'cascade'}),
  normRequirementId: integer('norm_requirement_id').references(() => normRequirement.id),
  description: text('description').notNull(),
  externalManagementUnitId: integer('external_management_unit_id').references(() => managementUnit.id, {onDelete: 'cascade'}),
},
  (t) => [{
    internalAuditIdx: index('internal_audit_idx').using('btree', t.internalAuditId),
    normRequirementIdx: index('norm_requirement_idx').using('btree', t.normRequirementId),
    externalManagementUnitId: index('external_management_unit_idx').using('btree', t.externalManagementUnitId),
  }]
);
