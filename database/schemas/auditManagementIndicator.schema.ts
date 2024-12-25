import { index, integer, serial } from "drizzle-orm/pg-core";
import { schema } from "./schema.ts";
import { auditManagement } from "./auditManagement.schema.ts";
import { indicator } from "./indicator.schema.ts";

export const auditManagementIndicator = schema.table(
  "audit_management_indicator",
  {
    id: serial("id").primaryKey().notNull(),
    auditManagementId: integer("audit_management_id").notNull().references(
      () => auditManagement.id,
      { onDelete: "cascade" },
    ),
    indicatorId: integer("indicator_id").notNull().references(
      () => indicator.id,
      { onDelete: "cascade" },
    ),
  },
  (t) => [{
    auditManagementIdx: index("audit_management_idx").using(
      "btree",
      t.auditManagementId,
    ),
    indicatorIdx: index("indicator_idx").using("btree", t.indicatorId),
  }],
);
