import {
  bigserial,
  index,
  integer,
  text,
  timestamp,
  varchar,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { users } from "./users.schema.ts";

export const emailHistory = schema.table('email_history', {
  id: bigserial('id', {mode: 'number'}).primaryKey().notNull(),
  senderId: integer('sender_id').notNull().references(() => users.id),
  subject: varchar('subject', {length: 160}).notNull(),
  message: text('message').notNull(),
  recipientId: integer('recipient_id').notNull().references(() => users.id),
  sentAt: timestamp('sent_at', {withTimezone: true}).notNull(),
},
  (t) => [{
    senderIdx: index('sender_idx').using('btree', t.senderId),
    recipientIdx: index('recipient_idx').using('btree', t.recipientId),
  }]
);
