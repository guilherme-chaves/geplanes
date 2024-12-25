import {
  index,
  integer,
  serial,
  text,
  varchar,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { norm } from "./norm.schema.ts";

export const normRequirement = schema.table('norm_requirement', {
  id: serial('id').primaryKey().notNull(),
  description: text('description'),
  normId: integer('norm_id').notNull().references(() => norm.id, {onDelete: 'cascade'}),
  index: varchar('index', {length: 20}).notNull(),
},
  (t) => [{
    normIdx: index('norm_idx').using('btree', t.normId)
  }]
);