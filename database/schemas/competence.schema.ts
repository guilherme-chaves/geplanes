import { index, integer, serial } from "drizzle-orm/pg-core";
import { schema } from "./schema.ts";
import { competenceMap } from "./competenceMap.schema.ts";
import { organizationalCompetence } from "./organizationalCompetence.schema.ts";

export const competence = schema.table("competence", {
  id: serial("id").primaryKey().notNull(),
  competenceMapId: integer("competence_map_id").notNull().references(
    () => competenceMap.id,
    { onDelete: "cascade" },
  ),
  organizationalCompetenceId: integer("organizational_competence_id")
    .references(() => organizationalCompetence.id),
}, (t) => [{
  competenceMapIdx: index("competence_map_idx").using(
    "btree",
    t.competenceMapId,
  ),
  organizationalCompetenceIdx: index("organizational_competence_idx").using(
    "btree",
    t.organizationalCompetenceId,
  ),
}]);
