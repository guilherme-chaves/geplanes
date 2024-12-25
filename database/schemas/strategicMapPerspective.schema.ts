import {
  index,
  integer,
  serial,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { perspective } from "./perspective.schema.ts";
import { strategicMap } from "./strategicMap.schema.ts";

export const strategicMapPerspective = schema.table('strategic_map_perspective', {
  id: serial('id').primaryKey().notNull(),
  strategicMapId: integer('strategic_map_id').notNull().references(() => strategicMap.id, {onDelete: 'cascade'}),
  perspectiveId: integer('perspective_id').notNull().references(() => perspective.id),
  order: integer('order').notNull(),
},
  (t) => [{
    strategicMapIdx: index('strategic_map_idx').using('btree', t.strategicMapId),
    perspectiveIdx: index('perspective_idx').using('btree', t.perspectiveId),
  }]
);