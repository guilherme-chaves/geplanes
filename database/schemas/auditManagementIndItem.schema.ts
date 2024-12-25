import { bigserial, index, integer, text } from "drizzle-orm/pg-core";
import { schema } from "./schema.ts";
import { auditManagementIndicator } from "./auditManagementIndicator.schema.ts";
import { auditModelItem } from "./auditModelItem.schema.ts";
import { evalFactorItem } from "./evalFactorItem.schema.ts";

export const auditManagementIndicatorItem = schema.table(
  "audit_management_indicator_item",
  {
    id: bigserial("id", { mode: "number" }),
    auditManagementIndicatorId: integer("audit_management_indicator_id")
      .notNull().references(() => auditManagementIndicator.id, {
        onDelete: "cascade",
      }),
    auditModelItemId: integer("audit_model_item_id").notNull().references(() =>
      auditModelItem.id
    ),
    evalFactorItemId: integer("eval_factor_item_id").references(() =>
      evalFactorItem.id
    ),
    description: text("description"),
  },
  (t) => [{
    auditManagementIndicatorIdx: index("audit_management_indicator_idx").using(
      "btree",
      t.auditManagementIndicatorId,
    ),
    auditModelItemIdx: index("audit_model_item_idx").using(
      "btree",
      t.auditModelItemId,
    ),
    evalFactorItemIdx: index("eval_factor_item_idx").using(
      "btree",
      t.evalFactorItemId,
    ),
  }],
);
