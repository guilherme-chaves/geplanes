import {
  integer,
  uuid,
  varchar,
} from 'drizzle-orm/pg-core';
import { schema, fileContentType, bytea } from "./schema.ts";

export const files = schema.table('files', {
  id: uuid('id').primaryKey().notNull(),
  name: varchar('name', {length: 128}).notNull(),
  type: fileContentType('type').notNull(),
  size: integer('size').notNull(),
  content: bytea('content').notNull()
});
