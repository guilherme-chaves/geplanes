import { serial } from "drizzle-orm/pg-core";
import { schema } from "./schema.ts";

export const comment = schema.table("comment", {
  id: serial("id").primaryKey().notNull(),
});
