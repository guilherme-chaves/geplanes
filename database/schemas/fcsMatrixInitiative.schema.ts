import {
  boolean,
  index,
  integer,
  serial,
  varchar,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { fcsMatrix } from "./fcsMatrix.schema.ts";

export const fcsMatrixInitiative = schema.table('fcs_matrix_initiative', {
  id: serial('id').primaryKey().notNull(),
  fcsMatrixId: integer('fcs_matrix_id').notNull().references(() => fcsMatrix.id, {onDelete: 'cascade'}),
  description: varchar('description', {length: 160}).notNull(),
  priority: boolean().notNull(),
},
  (t) => [{
    fcsMatrixIdx: index('fcs_matrix_idx').using('btree', t.fcsMatrixId),
  }]
);
