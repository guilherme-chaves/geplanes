import {
  index,
  integer,
  serial,
  text,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { competenceMap } from "./competenceMap.schema.ts";

export const activity = schema.table('activity', {
  id: serial('id').primaryKey().notNull(),
  competenceMapId: integer('competence_map_id').notNull().references(() => competenceMap.id, {onDelete: 'cascade'}),
  description: text('description'),
},
  (t) => [{
    competenceMapIdx: index('competence_map_idx').using('btree', t.competenceMapId)
  }]
);
