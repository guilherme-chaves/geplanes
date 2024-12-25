import { serial, varchar } from "drizzle-orm/pg-core";
import { schema } from "./schema.ts";

export const auditModel = schema.table("audit_model", {
  id: serial("id").primaryKey().notNull(),
  name: varchar("name", { length: 128 }).notNull(),
});
