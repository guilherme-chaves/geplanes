import {
  serial,
  varchar,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";

export const hierarchicalLevel = schema.table('hierarchical_level', {
  id: serial('id').primaryKey().notNull(),
  description: varchar('description', {length: 160}).notNull(),
});
