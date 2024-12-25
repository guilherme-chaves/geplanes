import {
  doublePrecision,
  index,
  integer,
  serial,
  text,
  varchar,
} from "drizzle-orm/pg-core";
import { schema } from "./schema.ts";
import { managementUnit } from "./managementUnit.schema.ts";
import { measurementUnit } from "./measurementUnit.schema.ts";
import { strategicMapObjective } from "./strategicMapObjective.schema.ts";
import { users } from "./users.schema.ts";

export const indicator = schema.table("indicator", {
  id: serial("id").primaryKey().notNull(),
  name: varchar("name", { length: 128 }).notNull(),
  description: text("description"),
  weight: doublePrecision("weight").notNull(),
  precision: integer("precision"),
  tolerance: doublePrecision("tolerance"),
  frequency: integer("frequency"),
  bestValue: integer("best_value"),
  measurementUnitId: integer("measurement_unit_id").references(() =>
    measurementUnit.id
  ),
  status: integer("status").notNull(), // TODO
  userInChargeId: integer("user_in_charge_id").references(() => users.id),
  relevance: integer("relevance"),
  monitoringFrequency: integer("monitoring_frequency"),
  controlMechanismDesc: text("control_mechanism_desc"),
  dataSources: text("data_sources"),
  calculationFormula: text("calculation_formula"),
  managementUnitId: integer("management_unit_id").notNull().references(() =>
    managementUnit.id
  ),
  strategicMapObjectiveId: integer("strategic_map_objective_id").notNull()
    .references(() => strategicMapObjective.id),
}, (t) => [{
  strategicMapObjectiveIdx: index("strategic_map_objective_idx").using(
    "btree",
    t.strategicMapObjectiveId,
  ),
  managementUnitIdx: index("management_unit_idx").using(
    "btree",
    t.managementUnitId,
  ),
  measurementUnitIdx: index("measurement_unit_idx").using(
    "btree",
    t.measurementUnitId,
  ),
}]);
