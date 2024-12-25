import {
  index,
  integer,
  serial,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { evalFactorItem } from "./evalFactorItem.schema.ts";
import { fcsMatrixFactor } from "./fcsMatrixFactor.schema.ts";
import { fcsMatrixInitiative } from "./fcsMatrixInitiative.schema.ts";

export const fcsMatrixInitiativeFactor = schema.table('fcs_matrix_initiative_factor', {
  id: serial('id').primaryKey().notNull(),
  fcsMatrixInitiativeId: integer('fcs_matrix_initiative_id').notNull().references(() => fcsMatrixInitiative.id, {onDelete: 'cascade'}),
  fcsMatrixFactorId: integer('fcs_matrix_factor_id').notNull().references(() => fcsMatrixFactor.id, {onDelete: 'cascade'}),
  evalFactorItemId: integer('eval_factor_item_id').notNull().references(() => evalFactorItem.id),
},
  (t) => [{
    fcsMatrixInitiativeId: index('fcs_matrix_initiative_idx').using('btree', t.fcsMatrixInitiativeId),
    evalFactorItemIdx: index('eval_factor_item_idx').using('btree', t.evalFactorItemId),
    fcsMatrixFactorIdx: index('fcs_matrix_factor_idx').using('btree', t.fcsMatrixFactorId),
  }]
);
