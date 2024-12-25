import {
  bigserial,
  index,
  integer,
  numeric,
  varchar,
} from "drizzle-orm/pg-core";
import { schema } from "./schema.ts";
import { evalFactor } from "./evalFactor.schema.ts";

export const evalFactorItem = schema.table("eval_factor_item", {
  id: bigserial("id", { mode: "number" }).primaryKey().notNull(),
  evalFactorId: integer("eval_factor_id").notNull().references(
    () => evalFactor.id,
    { onDelete: "cascade" },
  ),
  value: numeric("value", { precision: 19, scale: 4 }).notNull(),
  description: varchar("description", { length: 160 }).notNull(),
}, (t) => [{
  evalFactorIdx: index("eval_factor_idx").using("btree", t.evalFactorId),
}]);
