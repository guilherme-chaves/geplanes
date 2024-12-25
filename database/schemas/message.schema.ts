import {
  boolean,
  serial,
  text,
  timestamp,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";

export const message = schema.table('message', {
  id: serial('id').primaryKey().notNull(),
  content: text('content').notNull(),
  sentAt: timestamp('sent_at', {withTimezone: true}).notNull(),
  visible: boolean('visible').notNull(),
});
