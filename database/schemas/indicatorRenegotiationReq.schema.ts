import {
  date,
  index,
  integer,
  serial,
  text,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { comment } from "./comment.schema.ts";
import { indicator } from "./indicator.schema.ts";
import { users } from "./users.schema.ts";

export const indicatorRenegotiationRequests = schema.table('indicator_renegotiation_requests', {
  id: serial('id').primaryKey().notNull(),
  status: integer('status').notNull(), // TODO
  indicatorId: integer('indicator_id').notNull().references(() => indicator.id, {onDelete: 'cascade'}),
  userId: integer('user_id').references(() => users.id),
  cancelReason: text('cancel_reason'),
  response: text('response'),
  requestedAt: date('requested_at').notNull(),
  commentId: integer('comment_id').references(() => comment.id),
},
  (t) => [{
    indicatorIdx: index('indicator_idx').using('btree', t.indicatorId),
    userIdx: index('user_idx').using('btree', t.userId),
    commentIdx: index('comment_idx').using('btree', t.commentId),
  }]
);