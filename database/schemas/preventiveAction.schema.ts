import { schema } from "./schema.ts";
import { date, index, integer, serial, text } from "drizzle-orm/pg-core";
import { managementUnit } from "./managementUnit.schema.ts";

export const preventiveAction = schema.table("preventive_action", {
  id: serial("id").primaryKey().notNull(),
  mUnitRecordId: integer("m_unit_record_id").notNull().references(() =>
    managementUnit.id
  ),
  createdAt: date("created_at").notNull(),
  finishedAt: date("finished_at"),
  origin: integer("origin"),
  description: text("description"),
  observations: text("observations"),
  conclusion: text("conclusion"),
  evalActionEficacy: integer("eval_action_eficacy"),
  actionEficacyDesc: text("action_eficacy_desc"),
  type: integer("type"), // TODO
  status: integer("status").notNull(),
}, (t) => [{
  mUnitRecordIdx: index("m_unit_record_idx").using("btree", t.mUnitRecordId),
}]);
