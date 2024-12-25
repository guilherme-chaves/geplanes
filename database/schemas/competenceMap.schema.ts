import {
  integer,
  serial,
  uniqueIndex,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { managementUnit } from "./managementUnit.schema.ts";

export const competenceMap = schema.table('competence_map', {
  id: serial('id').primaryKey().notNull(),
  managementUnitId: integer('management_unit_id').notNull().references(() => managementUnit.id, {onDelete: 'cascade'}),
},
  (t) => [{
    competenceMapUk: uniqueIndex('competence_map_uk').using('btree', t.managementUnitId)
  }]
);
