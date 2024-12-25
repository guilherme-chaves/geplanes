import {
  bigserial,
  index,
  integer,
  text,
  timestamp,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { comment } from "./comment.schema.ts";
import { users } from "./users.schema.ts";

export const commentItem = schema.table('comment_item', {
  id: bigserial('id', {mode: 'number'}).primaryKey().notNull(),
  commentId: integer('comment_id').notNull().references(() => comment.id, {onDelete: 'cascade'}),
  userId: integer('user_id').notNull().references(() => users.id),
  commentText: text('text').notNull(),
  sentAt: timestamp('sent_at', {withTimezone: true}).notNull(),
},
  (t) => [{
    commentIdx: index('comment_idx').using('btree', t.commentId),
    userIdx: index('user_idx').using('btree', t.userId),
  }]
);