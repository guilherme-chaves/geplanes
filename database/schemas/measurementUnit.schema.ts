import {
  serial,
  varchar,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";

export const measurementUnit = schema.table('measurement_unit', {
  id: serial('id').primaryKey().notNull(),
  name: varchar('name', {length: 128}).notNull(),
  acronym: varchar('acronym', {length: 16}).notNull(),
});
