import {
  boolean,
  serial,
  varchar,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";

export const evalFactor = schema.table('eval_factor', {
  id: serial('id').primaryKey().notNull(),
  name: varchar('name', {length: 128}).notNull(),
  useFcsMatrix: boolean('use_fcs_matrix'),
});
