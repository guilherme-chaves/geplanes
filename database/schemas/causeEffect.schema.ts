import {
  foreignKey,
  index,
  integer,
  serial,
  varchar,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { anomaly } from "./anomaly.schema.ts";

export const causeEffect = schema.table('cause_effect', {
  id: serial('id').primaryKey().notNull(),
  description: varchar('description', {length: 160}).notNull(),
  effectId: integer('effect_id'),
  anomalyId: integer('anomaly_id').references(() => anomaly.id)
},
  (t) => [{
    effectFk: foreignKey({
      columns: [t.effectId],
      foreignColumns: [t.id],
      name: 'cause_effect_effect_id_fk',
    }),
    effectIdx: index('effect_idx').using('btree', t.effectId),
    anomalyIdx: index('anomaly_idx').using('btree', t.anomalyId),
  }]
);
