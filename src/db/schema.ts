import { Buffer } from 'node:buffer';
import {
  boolean,
  bigint,
  bigserial,
  date,
  doublePrecision,
  integer,
  numeric,
  serial,
  smallint,
  pgSchema,
  text,
  timestamp,
  uuid,
  varchar,
  customType,
  unique,
  index,
  uniqueIndex,
  foreignKey
} from 'drizzle-orm/pg-core';

export const bytea = customType<{data: Buffer; notNull: false; default: false}>({
  dataType() {
    return 'bytea';
  }
});

export const schema = pgSchema('geplanes_bsc');

export const fileContentType = schema.enum('file_content_type', [
  'application/pdf',                // .pdf
  'application/zip',                // .zip
  'application/vnd.rar',            // .rar
  'application/vnd.ms-excel',       // .xls .xlsx
  'application/vnd.ms-powerpoint',  // .ppt .pptx
  'application/msword',             // .doc .docx
  'image/jpeg',                     // .jpg .jpeg
  'image/png',                      // .png
  'image/bmp',                      // .bmp
  'image/webp',                     // .webp
  'image/heic',                     // .heic
  'text/csv',                       // .csv
  'text/richtext',                  // .rtf
  'text/plain',                     // .txt
  'audio/mpeg',                     // .mp3
  'audio/mp4',                      // .mp4
  'audio/vorbis',                   // .ogg
  'audio/opus',
  'audio/ogg',
]);

export const permissonType = schema.enum('permission_type', [
  'ACCESS',
  'SEARCH',
  'EDIT',
  'NONE'
]);

export const preventiveAction = schema.table('preventive_action', {
  id: serial('id').primaryKey().notNull(),
  mUnitRecordId: integer('m_unit_record_id').notNull().references(() => managementUnit.id),
  createdAt: date('created_at').notNull(),
  finishedAt: date('finished_at'),
  origin: integer('origin'),
  description: text('description'),
  observations: text('observations'),
  conclusion: text('conclusion'),
  evalActionEficacy: integer('eval_action_eficacy'),
  actionEficacyDesc: text('action_eficacy_desc'),
  type: integer('type'), // TODO
  status: integer('status').notNull()
},
  (t) => [{
    mUnitRecordIdx: index('m_unit_record_idx').using('btree', t.mUnitRecordId)
  }]
);

export const anomaly = schema.table('anomaly', {
  id: serial('id').primaryKey().notNull(),
  conclusion: text('conclusion'),
  createdAt: date('created_at').notNull(),
  finishedAt: date('finished_at'),
  description: text('description'),
  location: integer('location').notNull(),
  immediateCounterMeasures: text('immediate_counter_measures'),
  mUnitResponsibleId: integer('m_unit_responsible_id').notNull().references(() => managementUnit.id),
  mUnitRecordId: integer('m_unit_record_id').notNull().references(() => managementUnit.id),
  observations: text('observations'),
  classification: integer('classification'),
  personInCharge: integer('person_in_charge').notNull().references(() => users.id),
  verificationDesc: text('verification'),
  standardizationDesc: text('standardization'),
  occurrenceId: integer('occurrence_id').references(() => occurrence.id),
  anomalySourceDesc: text('anomaly_source_desc'),
  unlockedAt: date('unlocked_at'),
  reminderSent: boolean('reminded_sent'),
  status: integer('status').notNull(), // TODO
  statusProcessing: integer('status_processing'), // TODO
  type: integer(), // TODO
  anomalySource: integer('anomaly_source'),
  closureRequestedAt: date('closure_requested_at'),
  subordinationId: integer('subordination_id'),
  auditType: varchar('audit_type', {length: 255}), // TODO
  internalAuditItemId: bigint('internal_audit_item_id', {mode: 'number'}).references(() => internalAuditItem.id),
},
  (t) => [{
    subordinationFk: foreignKey({
      columns: [t.subordinationId],
      foreignColumns: [t.id],
      name: 'anomaly_subordination_id_fk',
    }).onDelete('cascade'),
    mUnitRecordIdx: index('m_unit_record_idx').using('btree', t.mUnitRecordId),
    internalAuditItemIdx: index('internal_audit_item_idx').using('btree', t.internalAuditItemId),
    occurrenceIdx: index('occurrence_idx').using('btree', t.occurrenceId),
    subordinationIdx: index('subordination_idx').using('btree', t.subordinationId),
    mUnitResponsibleIdx: index('m_unit_responsible_idx').using('btree', t.mUnitResponsibleId),
  }]
);

export const files = schema.table('files', {
  id: uuid('id').primaryKey().notNull(),
  name: varchar('name', {length: 128}).notNull(),
  type: fileContentType('type').notNull(),
  size: integer('size').notNull(),
  content: bytea('content').notNull()
});

export const indicatorMonitoring = schema.table('indicator_monitoring', {
  id: serial('id').primaryKey().notNull(),
  index: integer('index').notNull(),
  createdAt: date('created_at').notNull(),
  finishedAt: date('finished_at'),
  maxValue: numeric('max_value', {precision: 19, scale: 4}),
  minValue: numeric('min_value', {precision: 19, scale: 4}),
  realValue: numeric('real_value', {precision: 19, scale: 4}),
  baseValueStatus: boolean('base_value_status'),
  realValueStatus: boolean('real_value_status'),
  indicatorId: integer('indicator_id').notNull().references(() => indicator.id, {onDelete: 'cascade'}),
  anomalyId: integer('anomaly_id').references(() => anomaly.id),
  resultReminderDate: date('result_reminder_date'),
  preventiveActionId: integer('preventive_action_id').references(() => preventiveAction.id),
  notApplicable: boolean('not_applicable'),
},
  (t) => [{
    indicatorMonitoringUk: unique('indicator_monitoring_uk').on(t.indicatorId, t.index, t.createdAt, t.finishedAt),
    indicatorIdx: index('indicator_idx').using('btree', t.indicatorId),
    anomalyIdx: index('anomaly_idx').using('btree', t.anomalyId),
    preventiveActionIdx: index('preventive_actio_idx').using('btree', t.preventiveActionId)
  }]
);

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

export const anomalyFiles = schema.table('anomaly_files', {
  id: serial('id').primaryKey().notNull(),
  name: varchar('name', {length: 128}).notNull(),
  description: text('description'),
  fileId: uuid('file_id').notNull().references(() => files.id),
  anomalyId: integer('anomaly_id').notNull().references(() => anomaly.id, {onDelete: 'cascade'}),
},
  (t) => [{
    anomalyIdx: index('anomaly_idx').using('btree', t.anomalyId),
    fileIdx: index('file_idx').using('btree', t.fileId)
  }]
);

export const activity = schema.table('activity', {
  id: serial('id').primaryKey().notNull(),
  competenceMapId: integer('competence_map_id').notNull().references(() => competenceMap.id, {onDelete: 'cascade'}),
  description: text('description'),
},
  (t) => [{
    competenceMapIdx: index('competence_map_idx').using('btree', t.competenceMapId)
  }]
);

export const auditManagement = schema.table('audit_management', {
  id: serial('id').primaryKey().notNull(),
  description: text('description').notNull(),
  managementUnitId: integer('management_unit_id').notNull().references(() => managementUnit.id),
  auditModelId: integer('audit_model_id').notNull().references(() => auditModel.id),
  personInCharge: integer('person_in_charge').notNull().references(() => users.id),
  auditDate: date('audit_date').notNull(),
},
  (t) => [{
    auditModelIdx: index('audit_model_idx').using('btree', t.auditModelId),
    managementUnitIdx: index('management_unit_idx').using('btree', t.managementUnitId)
  }]
);

export const auditManagementIndicator = schema.table('audit_management_indicator', {
  id: serial('id').primaryKey().notNull(),
  auditManagementId: integer('audit_management_id').notNull().references(() => auditManagement.id, {onDelete: 'cascade'}),
  indicatorId: integer('indicator_id').notNull().references(() => indicator.id, {onDelete: 'cascade'})
},
  (t) => [{
    auditManagementIdx: index('audit_management_idx').using('btree', t.auditManagementId),
    indicatorIdx: index('indicator_idx').using('btree', t.indicatorId)
  }]
);

export const auditManagementIndicatorItem = schema.table('audit_management_indicator_item', {
  id: bigserial('id', {mode: 'number'}),
  auditManagementIndicatorId: integer('audit_management_indicator_id').notNull().references(() => auditManagementIndicator.id, {onDelete: 'cascade'}),
  auditModelItemId: integer('audit_model_item_id').notNull().references(() => auditModelItem.id),
  evalFactorItemId: integer('eval_factor_item_id').references(() => evalFactorItem.id),
  description: text('description'),
},
  (t) => [{
    auditManagementIndicatorIdx: index('audit_management_indicator_idx').using('btree', t.auditManagementIndicatorId),
    auditModelItemIdx: index('audit_model_item_idx').using('btree', t.auditModelItemId),
    evalFactorItemIdx: index('eval_factor_item_idx').using('btree', t.evalFactorItemId),
  }]
);

export const internalAudit = schema.table('internal_audit', {
  id: serial('id').primaryKey().notNull(),
  mUnitRecordId: integer('m_unit_record_id').notNull().references(() => managementUnit.id),
  mUnitResponsibleId: integer('m_unit_responsible_id').notNull().references(() => managementUnit.id),
  auditDate: date('audit_date').notNull(),
  observations: text('observations'),
  normId: integer('norm_id').notNull().references(() => norm.id),
  status: integer('status').notNull(), // TODO
  finishedAt: date('finished_at'),
},
  (t) => [{
    mUnitRecordIdx: index('m_unit_record_idx').using('btree', t.mUnitRecordId),
    mUnitResponsibleIdx: index('m_unit_responsible_idx').using('btree', t.mUnitResponsibleId),
    normIdx: index('norm_idx').using('btree', t.normId),
  }]
);

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

export const comment = schema.table('comment', {
  id: serial('id').primaryKey().notNull(),
});

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

export const competence = schema.table('competence', {
  id: serial('id').primaryKey().notNull(),
  competenceMapId: integer('competence_map_id').notNull().references(() => competenceMap.id, {onDelete: 'cascade'}),
  organizationalCompetenceId: integer('organizational_competence_id').references(() => organizationalCompetence.id),
},
  (t) => [{
    competenceMapIdx: index('competence_map_idx').using('btree', t.competenceMapId),
    organizationalCompetenceIdx: index('organizational_competence_idx').using('btree', t.organizationalCompetenceId),
  }]
);

export const organizationalCompetence = schema.table('organizational_competence', {
  id: serial('id').primaryKey().notNull(),
  name: varchar('name', {length: 128}).notNull(),
  description: text('description'),
});

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

export const evalFactor = schema.table('eval_factor', {
  id: serial('id').primaryKey().notNull(),
  name: varchar('name', {length: 128}).notNull(),
  useFcsMatrix: boolean('use_fcs_matrix'),
});

export const indicator = schema.table('indicator', {
  id: serial('id').primaryKey().notNull(),
  name: varchar('name', {length: 128}).notNull(),
  description: text('description'),
  weight: doublePrecision('weight').notNull(),
  precision: integer('precision'),
  tolerance: doublePrecision('tolerance'),
  frequency: integer('frequency'),
  bestValue: integer('best_value'),
  measurementUnitId: integer('measurement_unit_id').references(() => measurementUnit.id),
  status: integer('status').notNull(), // TODO
  userInChargeId: integer('user_in_charge_id').references(() => users.id),
  relevance: integer('relevance'),
  monitoringFrequency: integer('monitoring_frequency'),
  controlMechanismDesc: text('control_mechanism_desc'),
  dataSources: text('data_sources'),
  calculationFormula: text('calculation_formula'),
  managementUnitId: integer('management_unit_id').notNull().references(() => managementUnit.id),
  strategicMapObjectiveId: integer('strategic_map_objective_id').notNull().references(() => strategicMapObjective.id),
},
  (t) => [{
    strategicMapObjectiveIdx: index('strategic_map_objective_idx').using('btree', t.strategicMapObjectiveId),
    managementUnitIdx: index('management_unit_idx').using('btree', t.managementUnitId),
    measurementUnitIdx: index('measurement_unit_idx').using('btree', t.measurementUnitId),
  }]
);

export const indicatorAlert = schema.table('indicator_alert', {
  id: serial('id').primaryKey().notNull(),
  indicatorMonitoringId: integer('indicator_monitoring_id').references(() => indicatorMonitoring.id, {onDelete: 'set null'}),
  alertId: integer('alert_id'), // TODO
  indicatorId: integer('indicator_id').references(() => dashboardSyncIndicator.indicatorId),
});

export const dashboardSyncIndicator = schema.table('dashboard_sync_indicator', {
  indicatorId: integer('indicator_id').notNull().references(() => indicator.id),
  syncDate: timestamp('sync_date', {withTimezone: true}),
  errorCode: integer('error_code'),
  errorMessage: text('error_message'),
  created: boolean('created'),
  deleted: boolean('deleted')
});

export const initiative = schema.table('initiative', {
  id: serial('id').primaryKey().notNull(),
  managementUnitId: integer('management_unit_id').notNull().references(() => managementUnit.id),
  strategicMapObjectiveId: integer('strategic_map_objective_id').notNull().references(() => strategicMapObjective.id),
  description: text('description').notNull(),
},
  (t) => [{
    strategicMapObjectiveIdx: index('strategic_map_objective_idx').using('btree', t.strategicMapObjectiveId),
    managementUnitIdx: index('management_unit_idx').using('btree', t.managementUnitId),
  }]
);

export const internalAuditItem = schema.table('internal_audit_item', {
  id: bigserial('id', {mode: 'number'}).primaryKey().notNull(),
  internalAuditId: integer('internal_audit_id').notNull().references(() => internalAudit.id, {onDelete: 'cascade'}),
  normRequirementId: integer('norm_requirement_id').references(() => normRequirement.id),
  description: text('description').notNull(),
  externalManagementUnitId: integer('external_management_unit_id').references(() => managementUnit.id, {onDelete: 'cascade'}),
},
  (t) => [{
    internalAuditIdx: index('internal_audit_idx').using('btree', t.internalAuditId),
    normRequirementIdx: index('norm_requirement_idx').using('btree', t.normRequirementId),
    externalManagementUnitId: index('external_management_unit_idx').using('btree', t.externalManagementUnitId),
  }]
);

export const evalFactorItem = schema.table('eval_factor_item', {
  id: bigserial('id', {mode: 'number'}).primaryKey().notNull(),
  evalFactorId: integer('eval_factor_id').notNull().references(() => evalFactor.id, {onDelete: 'cascade'}),
  value: numeric('value', {precision: 19, scale: 4}).notNull(),
  description: varchar('description', {length: 160}).notNull(),
},
  (t) => [{
    evalFactorIdx: index('eval_factor_idx').using('btree', t.evalFactorId),
  }]
);

export const auditModelItem = schema.table('audit_model_item', {
  id: serial('id').primaryKey().notNull(),
  auditModelId: integer('audit_model_id').notNull().references(() => auditModel.id, {onDelete: 'cascade'}),
  name: varchar('name', {length: 128}).notNull(),
  description: text('description'),
  evalFactorId: integer('eval_factor_id').references(() => evalFactor.id),
  order: integer('order').notNull(),
},
  (t) => [{
    auditModelIdx: index('audit_model_idx').using('btree', t.auditModelId),
    evalFactorIdx: index('eval_factor_idx').using('btree', t.evalFactorId),
  }]
);

export const proceduresLogs = schema.table('procedures_logs', {
  id: bigserial('id', {mode: 'number'}).primaryKey().notNull(),
  resultReminder: timestamp('result_reminder', {withTimezone: true}),
  anomalyStatusUpdate: timestamp('anomaly_status_update', {withTimezone: true}),
  anomalyFixReminder: timestamp('date_anomaly_fix_reminder', {withTimezone: true}),
  indicatorCreationReminder: timestamp('indicator_creation_reminder', {withTimezone: true}),
  resultReleaseUpdate: timestamp('result_release_update', {withTimezone: true}),
});

export const competenceMap = schema.table('competence_map', {
  id: serial('id').primaryKey().notNull(),
  managementUnitId: integer('management_unit_id').notNull().references(() => managementUnit.id, {onDelete: 'cascade'}),
},
  (t) => [{
    competenceMapUk: uniqueIndex('competence_map_uk').using('btree', t.managementUnitId)
  }]
);

export const strategicMap = schema.table('strategic_map', {
  id: serial('id').primaryKey().notNull(),
  managementUnitId: integer('management_unit_id').notNull().references(() => managementUnit.id, {onDelete: 'cascade'}),
  description: text('description'),
},
  (t) => [{
    strategicMapUk: uniqueIndex('strategic_map_uk').using('btree', t.managementUnitId)
  }]
);

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

export const fcsMatrix = schema.table('fcs_matrix', {
  id: serial('id').primaryKey().notNull(),
  managementUnitId: integer('management_unit_id').notNull().references(() => managementUnit.id),
  strategicMapObjectiveId: integer('strategic_map_objective_id').notNull().references(() => strategicMapObjective.id),
  evalFactorId: integer('eval_factor_id').notNull().references(() => evalFactor.id),
},
  (t) => [{
    fcsMatrixUk: unique('fcs_matrix_uk').on(t.managementUnitId, t.strategicMapObjectiveId),
    managementUnitIdx: index('management_unit_idx').using('btree', t.managementUnitId),
    strategicMapObjectiveIdx: index('strategic_map_objective_idx').using('btree', t.strategicMapObjectiveId),
    evalFactorIdx: index('eval_factor_idx').using('btree', t.evalFactorId)
  }]
);

export const fcsMatrixFactor = schema.table('fcs_matrix_factor', {
  id: serial('id').primaryKey().notNull(),
  fcsMatrixId: integer('fcs_matrix_id').notNull().references(() => fcsMatrix.id, {onDelete: 'cascade'}),
  description: varchar('description', {length: 160}).notNull(),
},
  (t) => [{
    fcsMatrixIdx: index('fcs_matrix_idx').using('btree', t.fcsMatrixId),
  }]
);

export const fcsMatrixInitiative = schema.table('fcs_matrix_initiative', {
  id: serial('id').primaryKey().notNull(),
  fcsMatrixId: integer('fcs_matrix_id').notNull().references(() => fcsMatrix.id, {onDelete: 'cascade'}),
  description: varchar('description', {length: 160}).notNull(),
  priority: boolean().notNull(),
},
  (t) => [{
    fcsMatrixIdx: index('fcs_matrix_idx').using('btree', t.fcsMatrixId),
  }]
);

export const fcsMatrixInitiativeFactor = schema.table('fcs_matrix_initiative_factor', {
  id: serial('id').primaryKey().notNull(),
  fcsMatrixInitiativeId: integer('fcs_matrix_initiative_id').notNull().references(() => fcsMatrixInitiative.id, {onDelete: 'cascade'}),
  fcsMatrixFactorId: integer('fcs_matrix_factor_id').notNull().references(() => fcsMatrixFactor.id, {onDelete: 'cascade'}),
  evalFactorItemId: integer('eval_factor_item_id').notNull().references(() => evalFactorItem.id),
},
  (t) => [{
    fcsMatrixInitiativeId: index('fcs_matrix_initiative_idx').using('btree', t.fcsMatrixInitiativeId),
    evalFactorItemIdx: index('eval_factor_item_idx').using('btree', t.evalFactorItemId),
    fcsMatrixFactorIdx: index('fcs_matrix_factor_idx').using('btree', t.fcsMatrixFactorId),
  }]
);

export const message = schema.table('message', {
  id: serial('id').primaryKey().notNull(),
  content: text('content').notNull(),
  sentAt: timestamp('sent_at', {withTimezone: true}).notNull(),
  visible: boolean('visible').notNull(),
});

export const auditModel = schema.table('audit_model', {
  id: serial('id').primaryKey().notNull(),
  name: varchar('name', {length: 128}).notNull(),
});

export const hierarchicalLevel = schema.table('hierarchical_level', {
  id: serial('id').primaryKey().notNull(),
  description: varchar('description', {length: 160}).notNull(),
});

export const norm = schema.table('norm', {
  id: serial('id').primaryKey().notNull(),
  name: varchar('name', {length: 128}).notNull(),
  description: text('description'),
});

export const strategicObjective = schema.table('strategic_objective', {
  id: serial('id').primaryKey().notNull(),
  description: varchar('description', {length: 255}).notNull(),
})

export const strategicMapObjective = schema.table('strategic_map_objective', {
  id: serial('id').primaryKey().notNull(),
  strategicMapPerspectiveId: integer('strategic_map_perspective_id').notNull().references(() => strategicMapPerspective.id),
  strategicObjectiveId: integer('strategic_objective_id').notNull().references(() => strategicObjective.id)
},
  (t) => [{
    strategicObjetiveIdx: index('strategic_objective_idx').using('btree', t.strategicObjectiveId),
    strategicMapPerspectiveIdx: index('strategic_map_perspective_id').using('btree', t.strategicMapPerspectiveId)
  }]
);

export const occurrence = schema.table('occurrence', {
  id: serial('id').primaryKey().notNull(),
  description: text('description'),
  occurrenceDate: date('occurrence_date').notNull(),
  status: varchar('status', {length: 160}),
  managementUnitId: integer('management_unit_id').notNull().references(() => managementUnit.id, {onDelete: 'cascade'}),
  reporterId: integer('reporter_id').references(() => users.id),
  repeatedIncident: boolean('repeated_incident'),
  immediateCountermeasures: text('immediate_countermeasures'),
  number: integer('number').notNull(), // TODO
},
  (t) => [{
    managementUnitIdx: index('management_unit_idx').using('btree', t.managementUnitId),
    reporterIdx: index('reporter_idx').using('btree', t.reporterId),
  }]
);

export const filterIndicatorPanel = schema.table('filter_indicator_panel', {
  id: serial('id').primaryKey().notNull(),
  managementUnitId: integer('management_unit_id').notNull().references(() => managementUnit.id),
  strategicMapObjectiveId: integer('strategic_map_objetive_id').notNull().references(() => strategicMapObjective.id, {onDelete: 'cascade'}),
},
  (t) => [{
    strategicMapObjectiveIdx: index('strategic_map_objective_idx').using('btree', t.strategicMapObjectiveId),
    managementUnitIdx: index('management_unit_idx').using('btree', t.managementUnitId),
  }]
);

export const roles = schema.table('roles', {
  id: serial('id').primaryKey().notNull(),
  name: varchar('name', {length: 128}).notNull(),
},
  (t) => [{
    roleNameUk: unique('role_name_uk').on(t.name)
  }],
);

export const systemParams = schema.table('system_params', {
  id: serial('id').primaryKey().notNull(),
  smtpServer: varchar('smtp_server', {length: 160}).notNull(),
  smtpPort: integer('smtp_port').notNull(),
  smtpAuthRequired: boolean('smtp_auth_required').notNull(),
  smtpSslRequired: boolean('smtp_ssl_required').notNull(),
  smtpUser: varchar('smtp_user', {length: 160}).notNull(),
  smtpPassword: bytea('smtp_password'),
  smtpSender: varchar('smtp_sender', {length: 160}).notNull(),
  logoId: uuid('logo_id').references(() => files.id, {onDelete: 'set null'}),
  reportLogoId: uuid('report_logo_id').references(() => files.id, {onDelete: 'set null'}),
  notifyInvolvedUsersAnomaly: boolean('notify_involved_users_anomaly').notNull(), 
  timerCreateIndicatorTarget: integer('timer_create_indicator_target').notNull(),
  timerRealValuesUpdate: integer('timer_real_values_update').notNull(),
  timerAnomalyFixReminder: integer('timeranomaly_fix_reminder').notNull(),
  timerAnomalyFixLock: integer('timeranomaly_fix_lock').notNull(),
  timerAnomalyFixClosure: integer('timeranomaly_fix_closure').notNull(),
},
  (t) => [{
    logoIdx: index('logo_idx').using('btree', t.logoId),
    reportLogoIdx: index('report_logo_idx').using('btree', t.reportLogoId),
  }]
);

export const permissions = schema.table('permissions', {
  id: serial('id').primaryKey().notNull(),
  roleId: integer('role_id').notNull().references(() => roles.id, {onDelete: 'cascade'}),
  pageId: integer('page_id').notNull().references(() => pages.id, {onDelete: 'cascade'}),
  type: permissonType('type').notNull(),
},
  (t) => [{
    roleIdx: index('role_idx').using('btree', t.roleId),
    pageIdx: index('page_idx').using('btree', t.pageId),
  }]
);

export const perspective = schema.table('perspective', {
  id: serial('id').primaryKey().notNull(),
  description: varchar('description', {length: 160}).notNull(),
});

export const strategicMapPerspective = schema.table('strategic_map_perspective', {
  id: serial('id').primaryKey().notNull(),
  strategicMapId: integer('strategic_map_id').notNull().references(() => strategicMap.id, {onDelete: 'cascade'}),
  perspectiveId: integer('perspective_id').notNull().references(() => perspective.id),
  order: integer('order').notNull(),
},
  (t) => [{
    strategicMapIdx: index('strategic_map_idx').using('btree', t.strategicMapId),
    perspectiveIdx: index('perspective_idx').using('btree', t.perspectiveId),
  }]
);

export const actionPlan = schema.table('action_plan', {
  id: serial('id').primaryKey().notNull(),
  description: text('description').notNull(),
  descriptionHow: text('description_how'),
  descriptionWhy: text('description_why'),
  descriptionWho: text('description_who'),
  anomalyId: integer('anomaly_id').references(() => anomaly.id, {onDelete: 'cascade'}),
  planDate: date('plan_date'),
  status: integer('status'), // TODO
  statusUpdateDate: date('status_update_date'),
  preventiveActionId: integer('preventive_action_id').references(() => preventiveAction.id, {onDelete: 'cascade'}),
  managementUnitId: integer('management_unit_id').notNull().references(() => managementUnit.id),
  initiativeId: integer('initiative_id').references(() => initiative.id, {onDelete: 'cascade'}),
  userId: integer('user_id').references(() => users.id),
  amountP: integer('amount_p'),
  amountR: integer('amount_r'),
  measurementDescription: text(),
},
  (t) => [{
    anomalyIdx: index('anomaly_idx').using('btree', t.anomalyId),
    preventiveActionIdx: index('preventive_action_idx').using('btree', t.preventiveActionId),
    managementUnitIdx: index('management_unit_idx').using('btree', t.managementUnitId),
    initiativeIdx: index('initiative_idx').using('btree', t.initiativeId),
    userIdx: index('user_idx').using('btree', t.userId),
  }]
);

export const managementPlan = schema.table('management_plan', {
  id: serial('id').primaryKey().notNull(),
  description: text('description'),
  fiscalYear: smallint('fiscal_year').notNull(),
  indicatorsTargetCreationLimit: date('indicators_target_creation_limit').notNull(),
  indicatorsTargetCreationReminder: date('indicators_target_creation_reminder').notNull(),
  businessMapCreationLimit: date('business_map_creation_limit').notNull(),
  strategicMapCreationLimit: date('strategic_map_creation_limit').notNull(),
  competenceMapCreationLimit: date('competence_map_creation_limit').notNull(),
  fcsMatrixCreationLock: date('fcs_matrix_creation_lock').notNull(),
  q1ResultReleaseLock: date('q1_result_release_lock').notNull(),
  q1ResultReleaseLimit: date('q1_result_release_limit').notNull(),
  q2ResultReleaseLock: date('q2_result_release_lock').notNull(),
  q2ResultReleaseLimit: date('q2_result_release_limit').notNull(),
  q3ResultReleaseLock: date('q3_result_release_lock').notNull(),
  q3ResultReleaseLimit: date('q3_result_release_limit').notNull(),
  q4ResultReleaseLock: date('q4_result_release_lock').notNull(),
  q4ResultReleaseLimit: date('q4_result_release_limit').notNull(),
});

export const normRequirement = schema.table('norm_requirement', {
  id: serial('id').primaryKey().notNull(),
  description: text('description'),
  normId: integer('norm_id').notNull().references(() => norm.id, {onDelete: 'cascade'}),
  index: varchar('index', {length: 20}).notNull(),
},
  (t) => [{
    normIdx: index('norm_idx').using('btree', t.normId)
  }]
);

export const indicatorCancelRequests = schema.table('indicator_cancel_requests', {
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
    commentIdx: index('comment_idx').using('btree', t.commentId),
    userIdx: index('user_idx').using('btree', t.userId),
  }]
);

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

export const pages = schema.table('pages', {
  id: serial('id').primaryKey().notNull(),
  title: varchar('title', {length: 64}).notNull(),
  path: varchar('path', {length: 128}).notNull(),
});

export const managementUnit = schema.table('management_unit', {
  id: serial('id').primaryKey().notNull(),
  name: varchar('name', {length: 128}).notNull(),
  acronym: varchar('acronym', {length: 16}).notNull(),
  subordinationId: integer('subordination_id'),
  managementPlanId: integer('management_plan_id').notNull().references(() => managementPlan.id),
  hierarchicalLevelId: integer('hierarchical_level_id').notNull().references(() => hierarchicalLevel.id),
  qualityArea: boolean('quality_area').notNull(),
  internalAuditArea: boolean('internal_audit_area').notNull(),
  occurrences: integer('occurences').default(1),
  anomalies: integer('anomalies').default(1),
  preventiveActions: integer('preventive_actions').default(1),
  allowStrategicMap: boolean('allow_strategic_map'),
  allowBusinessMap: boolean('allow_business_map'),
  allowCompetenceMap: boolean('allow_competence_map'),
  allowFcsMatrix: boolean('allow_fcs_matrix'),
  level: integer('level').notNull(),
},
  (t) => [{
    subordinationFk: foreignKey({
      columns: [t.subordinationId],
      foreignColumns: [t.id],
      name: 'management_unit_subordination_id_fk'
    }),
    managementUnitUk: unique('management_unit_uk').on(t.name, t.managementPlanId),
    subordinationIdx: index('subordination_idx').using('btree', t.subordinationId),
    hierarchicalLevelIdx: index('hierarchical_level_idx').using('btree', t.hierarchicalLevelId),
  }]
);

export const measurementUnit = schema.table('measurement_unit', {
  id: serial('id').primaryKey().notNull(),
  name: varchar('name', {length: 128}).notNull(),
  acronym: varchar('acronym', {length: 16}).notNull(),
});

export const users = schema.table('users', {
  id: serial('id').primaryKey().notNull(),
  userName: varchar('user_name', {length: 48}).notNull(),
  email: varchar('email', {length: 128}).notNull(),
  password: bytea('password').notNull(),
  fullName: varchar('full_name', {length: 128}).notNull(),
  position: varchar('position', {length: 128}).notNull(), // TODO
  additionalInfo: text('additional_info'),
  profilePhotoId: uuid('profile_photo_id').references(() => files.id, {onDelete: 'set null'}),
  userRole: integer('userRole'), // TODO
  extension: varchar('extension', {length: 8}),
  banned: boolean('blocked').notNull(),
},
  (t) => [{
    userLoginUk: unique('user_login_uk').on(t.userName),
    profilePhotoId: index('profile_photo_idx').using('btree', t.profilePhotoId),
  }]
);

export const internalAuditUser = schema.table('internal_audit_user', {
  id: serial('id').primaryKey().notNull(),
  internalAuditId: integer('internal_audit_id').notNull().references(() => internalAudit.id, {onDelete: 'cascade'}),
  userName: varchar('user_name', {length: 48}).notNull(),
  position: varchar('position', {length: 128}).notNull(), // TODO
  userRole: integer('userRole'), // TODO
},
  (t) => [{
    internalAuditIdx: index('internal_audit_idx').using('btree', t.internalAuditId)
  }]
);

export const userRoles = schema.table('user_roles', {
  id: serial('id').notNull().primaryKey(),
  userId: integer('user_id').notNull().references(() => users.id, {onDelete: 'cascade'}),
  roleId: integer('role_id').notNull().references(() => roles.id, {onDelete: 'cascade'})
},
  (t) => [{
    userIdx: index('user_idx').using('btree', t.userId),
    roleIdx: index('role_idx').using('btree', t.roleId),
  }]
);

export const managementUnitUser = schema.table('management_unit_user', {
  id: serial('id').notNull().primaryKey(),
  userId: integer('user_id').notNull().references(() => users.id, {onDelete: 'cascade'}),
  managementUnitId: integer('management_unit_id').notNull().references(() => managementUnit.id, {onDelete: 'cascade'}),
},
  (t) => [{
    userIdx: index('user_idx').using('btree', t.userId),
    managementIdx: index('management_idx').using('btree', t.managementUnitId),
  }]
);
