import { date, index, integer, serial, text } from "drizzle-orm/pg-core";
import { schema } from "./schema.ts";
import { managementUnit } from "./managementUnit.schema.ts";
import { norm } from "./norm.schema.ts";

export const internalAudit = schema.table("internal_audit", {
  id: serial("id").primaryKey().notNull(),
  mUnitRecordId: integer("m_unit_record_id").notNull().references(() =>
    managementUnit.id
  ),
  mUnitResponsibleId: integer("m_unit_responsible_id").notNull().references(
    () => managementUnit.id,
  ),
  auditDate: date("audit_date").notNull(),
  observations: text("observations"),
  normId: integer("norm_id").notNull().references(() => norm.id),
  status: integer("status").notNull(), // TODO
  finishedAt: date("finished_at"),
}, (t) => [{
  mUnitRecordIdx: index("m_unit_record_idx").using("btree", t.mUnitRecordId),
  mUnitResponsibleIdx: index("m_unit_responsible_idx").using(
    "btree",
    t.mUnitResponsibleId,
  ),
  normIdx: index("norm_idx").using("btree", t.normId),
}]);
