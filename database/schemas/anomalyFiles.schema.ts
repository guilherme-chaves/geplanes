import {
  index,
  integer,
  serial,
  text,
  uuid,
  varchar,
} from "drizzle-orm/pg-core";
import { schema } from "./schema.ts";
import { anomaly } from "./anomaly.schema.ts";
import { files } from "./files.schema.ts";

export const anomalyFiles = schema.table("anomaly_files", {
  id: serial("id").primaryKey().notNull(),
  name: varchar("name", { length: 128 }).notNull(),
  description: text("description"),
  fileId: uuid("file_id").notNull().references(() => files.id),
  anomalyId: integer("anomaly_id").notNull().references(() => anomaly.id, {
    onDelete: "cascade",
  }),
}, (t) => [{
  anomalyIdx: index("anomaly_idx").using("btree", t.anomalyId),
  fileIdx: index("file_idx").using("btree", t.fileId),
}]);
