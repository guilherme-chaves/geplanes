import {
  boolean,
  foreignKey,
  index,
  integer,
  serial,
  unique,
  varchar,
} from "drizzle-orm/pg-core";
import { schema } from "./schema.ts";
import { hierarchicalLevel } from "./hierarchicalLevel.schema.ts";
import { managementPlan } from "./managementPlan.schema.ts";

export const managementUnit = schema.table("management_unit", {
  id: serial("id").primaryKey().notNull(),
  name: varchar("name", { length: 128 }).notNull(),
  acronym: varchar("acronym", { length: 16 }).notNull(),
  subordinationId: integer("subordination_id"),
  managementPlanId: integer("management_plan_id").notNull().references(() =>
    managementPlan.id
  ),
  hierarchicalLevelId: integer("hierarchical_level_id").notNull().references(
    () => hierarchicalLevel.id,
  ),
  qualityArea: boolean("quality_area").notNull(),
  internalAuditArea: boolean("internal_audit_area").notNull(),
  occurrences: integer("occurences").default(1),
  anomalies: integer("anomalies").default(1),
  preventiveActions: integer("preventive_actions").default(1),
  allowStrategicMap: boolean("allow_strategic_map"),
  allowBusinessMap: boolean("allow_business_map"),
  allowCompetenceMap: boolean("allow_competence_map"),
  allowFcsMatrix: boolean("allow_fcs_matrix"),
  level: integer("level").notNull(),
}, (t) => [{
  subordinationFk: foreignKey({
    columns: [t.subordinationId],
    foreignColumns: [t.id],
    name: "management_unit_subordination_id_fk",
  }),
  managementUnitUk: unique("management_unit_uk").on(t.name, t.managementPlanId),
  subordinationIdx: index("subordination_idx").using(
    "btree",
    t.subordinationId,
  ),
  hierarchicalLevelIdx: index("hierarchical_level_idx").using(
    "btree",
    t.hierarchicalLevelId,
  ),
}]);
