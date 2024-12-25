import {
  index,
  integer,
  serial,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { strategicMapPerspective } from "./strategicMapPerspective.schema.ts";
import { strategicObjective } from "./strategicObjective.schema.ts";

export const strategicMapObjective = schema.table('strategic_map_objective', {
  id: serial('id').primaryKey().notNull(),
  strategicMapPerspectiveId: integer('strategic_map_perspective_id').notNull().references(() => strategicMapPerspective.id),
  strategicObjectiveId: integer('strategic_objective_id').notNull().references(() => strategicObjective.id)
},
  (t) => [{
    strategicObjetiveIdx: index('strategic_objective_idx').using('btree', t.strategicObjectiveId),
    strategicMapPerspectiveIdx: index('strategic_map_perspective_id').using('btree', t.strategicMapPerspectiveId)
  }]
);