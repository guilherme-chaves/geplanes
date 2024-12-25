import { date, serial, smallint, text } from "drizzle-orm/pg-core";
import { schema } from "./schema.ts";

export const managementPlan = schema.table("management_plan", {
  id: serial("id").primaryKey().notNull(),
  description: text("description"),
  fiscalYear: smallint("fiscal_year").notNull(),
  indicatorsTargetCreationLimit: date("indicators_target_creation_limit")
    .notNull(),
  indicatorsTargetCreationReminder: date("indicators_target_creation_reminder")
    .notNull(),
  businessMapCreationLimit: date("business_map_creation_limit").notNull(),
  strategicMapCreationLimit: date("strategic_map_creation_limit").notNull(),
  competenceMapCreationLimit: date("competence_map_creation_limit").notNull(),
  fcsMatrixCreationLock: date("fcs_matrix_creation_lock").notNull(),
  q1ResultReleaseLock: date("q1_result_release_lock").notNull(),
  q1ResultReleaseLimit: date("q1_result_release_limit").notNull(),
  q2ResultReleaseLock: date("q2_result_release_lock").notNull(),
  q2ResultReleaseLimit: date("q2_result_release_limit").notNull(),
  q3ResultReleaseLock: date("q3_result_release_lock").notNull(),
  q3ResultReleaseLimit: date("q3_result_release_limit").notNull(),
  q4ResultReleaseLock: date("q4_result_release_lock").notNull(),
  q4ResultReleaseLimit: date("q4_result_release_limit").notNull(),
});
