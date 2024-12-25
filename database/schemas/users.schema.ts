import {
  boolean,
  index,
  integer,
  serial,
  text,
  unique,
  uuid,
  varchar,
} from "drizzle-orm/pg-core";
import { bytea, schema } from "./schema.ts";
import { files } from "./files.schema.ts";

export const users = schema.table("users", {
  id: serial("id").primaryKey().notNull(),
  userName: varchar("user_name", { length: 48 }).notNull(),
  email: varchar("email", { length: 128 }).notNull(),
  password: bytea("password").notNull(),
  fullName: varchar("full_name", { length: 128 }).notNull(),
  position: varchar("position", { length: 128 }).notNull(), // TODO
  additionalInfo: text("additional_info"),
  profilePhotoId: uuid("profile_photo_id").references(() => files.id, {
    onDelete: "set null",
  }),
  userRole: integer("userRole"), // TODO
  extension: varchar("extension", { length: 8 }),
  banned: boolean("blocked").notNull(),
}, (t) => [{
  userLoginUk: unique("user_login_uk").on(t.userName),
  profilePhotoId: index("profile_photo_idx").using("btree", t.profilePhotoId),
}]);
