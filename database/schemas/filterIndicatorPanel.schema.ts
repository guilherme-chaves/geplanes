import { index, integer, serial } from "drizzle-orm/pg-core";
import { schema } from "./schema.ts";
import { managementUnit } from "./managementUnit.schema.ts";
import { strategicMapObjective } from "./strategicMapObjective.schema.ts";

export const filterIndicatorPanel = schema.table("filter_indicator_panel", {
  id: serial("id").primaryKey().notNull(),
  managementUnitId: integer("management_unit_id").notNull().references(() =>
    managementUnit.id
  ),
  strategicMapObjectiveId: integer("strategic_map_objetive_id").notNull()
    .references(() => strategicMapObjective.id, { onDelete: "cascade" }),
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
