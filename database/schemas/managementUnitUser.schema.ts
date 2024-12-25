import {
  index,
  integer,
  serial,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { managementUnit } from "./managementUnit.schema.ts";
import { users } from "./users.schema.ts";

export const managementUnitUser = schema.table('management_unit_user', {
  id: serial('id').notNull().primaryKey(),
  userId: integer('user_id').notNull().references(() => users.id, {onDelete: 'cascade'}),
  managementUnitId: integer('management_unit_id').notNull().references(() => managementUnit.id, {onDelete: 'cascade'}),
},
  (t) => [{
    userIdx: index('user_idx').using('btree', t.userId),
    managementIdx: index('management_idx').using('btree', t.managementUnitId),
  }]
);