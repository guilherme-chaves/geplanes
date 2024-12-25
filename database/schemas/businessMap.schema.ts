import {
  integer,
  serial,
  text,
  uniqueIndex,
} from 'drizzle-orm/pg-core';
import { schema } from "./schema.ts";
import { managementUnit } from "./managementUnit.schema.ts";

export const businessMap = schema.table('business_map', {
  id: serial('id').primaryKey().notNull(),
  managementUnitId: integer('management_unit_id').notNull().references(() => managementUnit.id, {onDelete: 'cascade'}),
  mission: text('mission'),
  suppliers: text('suppliers'),
  supplies: text('supplies'),
  business: text('business'),
  staff: text('staff'),
  equipments: text('equipments'),
  products: text('products'),
  clients: text('clients'),
  product: text('product'),
  client: text('client'),
  qualityDescription: text('quality_description'),
  qualityIndicator: text('quality_indicator'),
  qualityExpression: text('quality_expression'),
  qualityFrequency: text('quality_frequency'),
  qualityTarget: text('quality_target'),
  costDescription: text('cost_description'),
  costIndicator: text('cost_indicator'),
  costExpression: text('cost_expression'),
  costFrequency: text('cost_frequency'),
  costTarget: text('cost_target'),
  deliverDescription: text('deliver_description'),
  deliverIndicator: text('deliver_indicator'),
  deliverExpression: text('deliver_expression'),
  deliverFrequency: text('deliver_frequency'),
  deliverTarget: text('deliver_target'),
  securityDescription: text('security_description'),
  securityIndicator: text('security_indicator'),
  securityExpression: text('security_expression'),
  securityFrequency: text('security_frequency'),
  securityTarget: text('security_target'),
},
  (t) => [{
    businessMapUk: uniqueIndex('business_map_uk').using('btree', t.managementUnitId)
  }]
);
