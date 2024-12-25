import {
  index,
  integer,
  serial,
  unique,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { evalFactor } from "./evalFactor.schema.ts";
import { managementUnit } from "./managementUnit.schema.ts";
import { strategicMapObjective } from "./strategicMapObjective.schema.ts";

export const fcsMatrix = schema.table('fcs_matrix', {
  id: serial('id').primaryKey().notNull(),
  managementUnitId: integer('management_unit_id').notNull().references(() => managementUnit.id),
  strategicMapObjectiveId: integer('strategic_map_objective_id').notNull().references(() => strategicMapObjective.id),
  evalFactorId: integer('eval_factor_id').notNull().references(() => evalFactor.id),
},
  (t) => [{
    fcsMatrixUk: unique('fcs_matrix_uk').on(t.managementUnitId, t.strategicMapObjectiveId),
    managementUnitIdx: index('management_unit_idx').using('btree', t.managementUnitId),
    strategicMapObjectiveIdx: index('strategic_map_objective_idx').using('btree', t.strategicMapObjectiveId),
    evalFactorIdx: index('eval_factor_idx').using('btree', t.evalFactorId)
  }]
);
