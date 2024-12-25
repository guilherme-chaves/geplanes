import {
  serial,
  unique,
  varchar,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";

export const roles = schema.table('roles', {
  id: serial('id').primaryKey().notNull(),
  name: varchar('name', {length: 128}).notNull(),
},
  (t) => [{
    roleNameUk: unique('role_name_uk').on(t.name)
  }],
);