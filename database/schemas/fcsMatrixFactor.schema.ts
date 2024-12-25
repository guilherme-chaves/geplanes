import { index, integer, serial, varchar } from "drizzle-orm/pg-core";
import { schema } from "./schema.ts";
import { fcsMatrix } from "./fcsMatrix.schema.ts";

export const fcsMatrixFactor = schema.table("fcs_matrix_factor", {
  id: serial("id").primaryKey().notNull(),
  fcsMatrixId: integer("fcs_matrix_id").notNull().references(
    () => fcsMatrix.id,
    { onDelete: "cascade" },
  ),
  description: varchar("description", { length: 160 }).notNull(),
}, (t) => [{
  fcsMatrixIdx: index("fcs_matrix_idx").using("btree", t.fcsMatrixId),
}]);
