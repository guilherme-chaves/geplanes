import { index, integer, serial, text, varchar } from "drizzle-orm/pg-core";
import { schema } from "./schema.ts";
import { auditModel } from "./auditModel.schema.ts";
import { evalFactor } from "./evalFactor.schema.ts";

export const auditModelItem = schema.table("audit_model_item", {
  id: serial("id").primaryKey().notNull(),
  auditModelId: integer("audit_model_id").notNull().references(
    () => auditModel.id,
    { onDelete: "cascade" },
  ),
  name: varchar("name", { length: 128 }).notNull(),
  description: text("description"),
  evalFactorId: integer("eval_factor_id").references(() => evalFactor.id),
  order: integer("order").notNull(),
}, (t) => [{
  auditModelIdx: index("audit_model_idx").using("btree", t.auditModelId),
  evalFactorIdx: index("eval_factor_idx").using("btree", t.evalFactorId),
}]);
