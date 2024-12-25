import { serial, text, varchar } from "drizzle-orm/pg-core";
import { schema } from "./schema.ts";

export const norm = schema.table("norm", {
  id: serial("id").primaryKey().notNull(),
  name: varchar("name", { length: 128 }).notNull(),
  description: text("description"),
});
