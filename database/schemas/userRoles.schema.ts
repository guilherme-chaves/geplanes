import { index, integer, serial } from "drizzle-orm/pg-core";
import { schema } from "./schema.ts";
import { roles } from "./roles.schema.ts";
import { users } from "./users.schema.ts";

export const userRoles = schema.table("user_roles", {
  id: serial("id").notNull().primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id, {
    onDelete: "cascade",
  }),
  roleId: integer("role_id").notNull().references(() => roles.id, {
    onDelete: "cascade",
  }),
}, (t) => [{
  userIdx: index("user_idx").using("btree", t.userId),
  roleIdx: index("role_idx").using("btree", t.roleId),
}]);
