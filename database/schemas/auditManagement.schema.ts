import { date, index, integer, serial, text } from "drizzle-orm/pg-core";
import { schema } from "./schema.ts";
import { auditModel } from "./auditModel.schema.ts";
import { managementUnit } from "./managementUnit.schema.ts";
import { users } from "./users.schema.ts";

export const auditManagement = schema.table("audit_management", {
  id: serial("id").primaryKey().notNull(),
  description: text("description").notNull(),
  managementUnitId: integer("management_unit_id").notNull().references(() =>
    managementUnit.id
  ),
  auditModelId: integer("audit_model_id").notNull().references(() =>
    auditModel.id
  ),
  personInCharge: integer("person_in_charge").notNull().references(() =>
    users.id
  ),
  auditDate: date("audit_date").notNull(),
}, (t) => [{
  auditModelIdx: index("audit_model_idx").using("btree", t.auditModelId),
  managementUnitIdx: index("management_unit_idx").using(
    "btree",
    t.managementUnitId,
  ),
}]);
