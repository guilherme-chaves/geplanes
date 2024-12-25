import {
  index,
  integer,
  serial,
  text,
  uuid,
  varchar,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { files } from "./files.schema.ts";
import { indicator } from "./indicator.schema.ts";

export const indicatorFiles = schema.table('indicator_files', {
  id: serial('id').primaryKey().notNull(),
  name: varchar('name', {length: 128}).notNull(),
  description: text('description'),
  fileId: uuid('file_id').notNull().references(() => files.id),
  indicatorId: integer('indicator_id').notNull().references(() => indicator.id, {onDelete: 'cascade'})
},
  (t) => [{
    indicatorIdx: index('anomaly_idx').using('btree', t.indicatorId),
    fileIdx: index('file_idx').using('btree', t.fileId)
  }]
);
