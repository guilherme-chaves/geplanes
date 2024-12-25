import {
  serial,
  varchar,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";

export const pages = schema.table('pages', {
  id: serial('id').primaryKey().notNull(),
  title: varchar('title', {length: 64}).notNull(),
  path: varchar('path', {length: 128}).notNull(),
});