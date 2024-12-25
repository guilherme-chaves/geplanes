import {
  serial,
  text,
  varchar,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";

export const organizationalCompetence = schema.table('organizational_competence', {
  id: serial('id').primaryKey().notNull(),
  name: varchar('name', {length: 128}).notNull(),
  description: text('description'),
});
