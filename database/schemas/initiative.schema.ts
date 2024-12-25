import { index, integer, serial, text } from "drizzle-orm/pg-core";
import { schema } from "./schema.ts";
import { managementUnit } from "./managementUnit.schema.ts";
import { strategicMapObjective } from "./strategicMapObjective.schema.ts";

export const initiative = schema.table("initiative", {
  id: serial("id").primaryKey().notNull(),
  managementUnitId: integer("management_unit_id").notNull().references(() =>
    managementUnit.id
  ),
  strategicMapObjectiveId: integer("strategic_map_objective_id").notNull()
    .references(() => strategicMapObjective.id),
  description: text("description").notNull(),
}, (t) => [{
  strategicMapObjectiveIdx: index("strategic_map_objective_idx").using(
    "btree",
    t.strategicMapObjectiveId,
  ),
  managementUnitIdx: index("management_unit_idx").using(
    "btree",
    t.managementUnitId,
  ),
}]);
