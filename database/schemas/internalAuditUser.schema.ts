import {
  index,
  integer,
  serial,
  varchar,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { internalAudit } from "./internalAudit.schema.ts";
import { roles } from "./roles.schema.ts";

export const internalAuditUser = schema.table('internal_audit_user', {
  id: serial('id').primaryKey().notNull(),
  internalAuditId: integer('internal_audit_id').notNull().references(() => internalAudit.id, {onDelete: 'cascade'}),
  userName: varchar('user_name', {length: 48}).notNull(),
  position: varchar('position', {length: 128}).notNull(), // TODO
  userRole: integer('userRole').references(() => roles.id),
},
  (t) => [{
    internalAuditIdx: index('internal_audit_idx').using('btree', t.internalAuditId)
  }]
);