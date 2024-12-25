import { serial, varchar } from "drizzle-orm/pg-core";
import { schema } from "./schema.ts";

export const strategicObjective = schema.table("strategic_objective", {
  id: serial("id").primaryKey().notNull(),
  description: varchar("description", { length: 255 }).notNull(),
});
