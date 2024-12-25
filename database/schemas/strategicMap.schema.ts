import { integer, serial, text, uniqueIndex } from "drizzle-orm/pg-core";
import { schema } from "./schema.ts";
import { managementUnit } from "./managementUnit.schema.ts";

export const strategicMap = schema.table("strategic_map", {
  id: serial("id").primaryKey().notNull(),
  managementUnitId: integer("management_unit_id").notNull().references(
    () => managementUnit.id,
    { onDelete: "cascade" },
  ),
  description: text("description"),
}, (t) => [{
  strategicMapUk: uniqueIndex("strategic_map_uk").using(
    "btree",
    t.managementUnitId,
  ),
}]);
