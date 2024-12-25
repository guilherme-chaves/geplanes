import { index, integer, serial } from "drizzle-orm/pg-core";
import { permissonType, schema } from "./schema.ts";
import { pages } from "./pages.schema.ts";
import { roles } from "./roles.schema.ts";

export const permissions = schema.table("permissions", {
  id: serial("id").primaryKey().notNull(),
  roleId: integer("role_id").notNull().references(() => roles.id, {
    onDelete: "cascade",
  }),
  pageId: integer("page_id").notNull().references(() => pages.id, {
    onDelete: "cascade",
  }),
  type: permissonType("type").notNull(),
}, (t) => [{
  roleIdx: index("role_idx").using("btree", t.roleId),
  pageIdx: index("page_idx").using("btree", t.pageId),
}]);
