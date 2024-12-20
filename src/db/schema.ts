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
  customType
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
  ugRegistryId: integer('ug_registry_id').notNull(), // TODO
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
});

export const anomaly = schema.table('anomaly', {
  id: serial('id').primaryKey().notNull(),
  conclusion: text('conclusion'),
  createdAt: date('created_at').notNull(),
  finishedAt: date('finished_at'),
  description: text('description'),
  location: integer('location').notNull(),
  immediateCounterMeasures: text('immediate_counter_measures'),
  ugInChargeId: integer('ug_in_charge_id').notNull(), // TODO
  ugRegistryId: integer('ug_registry_id').notNull(), // TODO
  observations: text('observations'),
  classification: integer('classification'),
  personInCharge: varchar('person_in_charge', {length: 100}), // TODO
  verificationDesc: text('verification'),
  standardizationDesc: text('standardization'),
  occurrenceId: integer('occurrence_id'), // TODO
  anomalySourceDesc: text('anomaly_source_desc'),
  unlockedAt: date('unlocked_at'),
  reminderSent: boolean('reminded_sent'),
  status: integer('status').notNull(), // TODO
  statusProcessing: integer('status_processing'), // TODO
  type: integer(), // TODO
  anomalySource: integer('anomaly_source'),
  closureRequestedAt: date('closure_requested_at'),
  subordinationId: integer('subordination_id'), // TODO
  auditType: varchar('audit_type', {length: 255}), // TODO
  internalAuditItemId: bigint('internal_audit_item_id', {mode: 'number'}).references(() => internalAuditItem.id),
});

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
  finished: date('finished_at'),
  maxValue: numeric('max_value', {precision: 19, scale: 4}),
  minValue: numeric('min_value', {precision: 19, scale: 4}),
  realValue: numeric('real_value', {precision: 19, scale: 4}),
  baseValueStatus: boolean('base_value_status'),
  realValueStatus: boolean('real_value_status'),
  indicatorId: integer('indicator_id').notNull().references(() => indicator.id),
  anomalyId: integer('anomaly_id').references(() => anomaly.id),
  resultReminderDate: date('result_reminder_date'),
  preventiveActionId: integer('preventive_action_id').references(() => preventiveAction.id),
  notApplicable: boolean('not_applicable'),
});

export const indicatorFiles = schema.table('indicator_files', {
  id: serial('id').primaryKey().notNull(),
  name: varchar('name', {length: 128}).notNull(),
  description: text('description'),
  fileId: uuid('file_id').notNull().references(() => files.id),
  indicatorId: integer('indicator_id').notNull().references(() => indicator.id)
});

export const anomalyFiles = schema.table('anomaly_files', {
  id: serial('id').primaryKey().notNull(),
  name: varchar('name', {length: 128}).notNull(),
  description: text('description'),
  fileId: uuid('file_id').notNull().references(() => files.id),
  anomalyId: integer('anomaly_id').notNull().references(() => anomaly.id),
});

export const activity = schema.table('activity', {
  id: serial('id').primaryKey().notNull(),
  competenceMapId: integer('competence_map_id').notNull(), // TODO
  description: text('description'),
});

export const auditManagement = schema.table('audit_management', {
  id: serial('id').primaryKey().notNull(),
  description: text('description').notNull(),
  managementUnitId: integer('management_unit_id').notNull(), // TODO
  auditModelId: integer('audit_model_id').notNull(), // TODO
  personInCharge: varchar('person_in_charge', {length: 100}),
  auditDate: date('audit_date').notNull(),
});

export const auditManagementIndicator = schema.table('audit_management_indicator', {
  id: serial('id').primaryKey().notNull(),
  auditManagementId: integer('audit_management_id').notNull().references(() => auditManagement.id),
  indicatorId: integer('indicator_id').notNull().references(() => indicator.id)
});

export const auditManagementIndicatorItem = schema.table('audit_management_indicator_item', {
  id: bigserial('id', {mode: 'number'}),
  auditManagementIndicatorId: integer('audit_management_indicator_id').notNull().references(() => auditManagementIndicator.id),
  auditModelItemId: integer('audit_model_item_id').notNull(), // TODO
  evalFactorItemId: integer('eval_factor_item_id'), // TODO
  description: text('description'),
});

export const internalAudit = schema.table('internal_audit', {
  id: serial('id').primaryKey().notNull(),
  ugRegistryId: integer('ug_registry_id').notNull(), // TODO
  ugInChargeId: integer('ug_in_charge_id').notNull(), // TODO
  auditDate: date('audit_date').notNull(),
  observations: text('observations'),
  normId: integer('norm_id').notNull(), // TODO
  status: integer('status').notNull(), // TODO
  finishedAt: date('finished_at'),
});

export const causeEffect = schema.table('cause_effect', {
  id: serial('id').primaryKey().notNull(),
  description: varchar('description', {length: 160}).notNull(),
  effectId: integer('effect_id'), // TODO
  anomalyId: integer('anomaly_id').references(() => anomaly.id)
});

export const comment = schema.table('comment', {
  id: serial('id').primaryKey().notNull(),
});

export const commentItem = schema.table('comment_item', {
  id: bigserial('id', {mode: 'number'}).primaryKey().notNull(),
  commentId: integer('comment_id').notNull().references(() => comment.id),
  userId: integer('user_id').notNull(), // TODO
  commentText: text('text').notNull(),
  sentAt: timestamp('sent_at', {withTimezone: true}).notNull(),
});

export const competence = schema.table('competence', {
  id: serial('id').primaryKey().notNull(),
  competenceMapId: integer('competence_map_id').notNull(), // TODO
  organizationalCompetenceId: integer('organizational_competence_id').references(() => organizationalCompetence.id),
});

export const organizationalCompetence = schema.table('organizational_competence', {
  id: serial('id').primaryKey().notNull(),
  name: varchar('name', {length: 128}).notNull(),
  description: text('description'),
});

export const emailHistory = schema.table('email_history', {
  id: bigserial('id', {mode: 'number'}).primaryKey().notNull(),
  senderId: integer('sender_id').notNull(), // TODO
  subject: varchar('subject', {length: 160}).notNull(),
  message: text('message').notNull(),
  recipientId: integer('recipient_id').notNull(), // TODO
  sentAt: timestamp('sent_at', {withTimezone: true}).notNull(),
});

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
  measurementUnitId: integer('measurement_unit_id'), // TODO
  status: integer('status').notNull(), // TODO
  userInChargeId: integer('user_in_charge_id'), // TODO
  relevance: integer('relevance'),
  monitoringFrequency: integer('monitoring_frequency'),
  controlMechanismDesc: text('control_mechanism_desc'),
  dataSources: text('data_sources'),
  calculationFormula: text('calculation_formula'),
  managementUnitId: integer('management_unit_id').notNull(), // TODO
  strategicMapObjectiveId: integer('strategic_map_objective_id').notNull(), // TODO
});

export const indicatorAlert = schema.table('indicator_alert', {
  id: serial('id').primaryKey().notNull(),
  indicatorMonitoringId: integer('indicator_monitoring_id').references(() => indicatorMonitoring.id),
  alertId: integer('alert_id'), // TODO
  indicatorId: integer('indicator_id').references(() => indicator.id),
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
  managementUnitId: integer('management_unit_id').notNull(), // TODO
  strategicMapObjectiveId: integer('strategic_map_objective_id').notNull(), // TODO
  description: text('description').notNull(),
});

export const internalAuditItem = schema.table('internal_audit_item', {
  id: bigserial('id', {mode: 'number'}).primaryKey().notNull(),
  internalAuditId: integer('internal_audit_id').notNull().references(() => internalAudit.id),
  normRequirementId: integer('norm_requirement_id'), // TODO
  description: text('description').notNull(),
  externalUgId: integer('external_ug_id'), // TODO
});

export const evalFactorItem = schema.table('eval_factor_item', {
  id: bigserial('id', {mode: 'number'}).primaryKey().notNull(),
  evalFactorId: integer('eval_factor_id').notNull().references(() => evalFactor.id),
  value: numeric('value', {precision: 19, scale: 4}).notNull(),
  description: varchar('description', {length: 160}).notNull(),
});

export const auditModelItem = schema.table('audit_model_item', {
  id: serial('id').primaryKey().notNull(),
  auditModelId: integer('audit_model_id').notNull(), // TODO
  name: varchar('name', {length: 128}).notNull(),
  description: text('description'),
  evalFactorId: integer('eval_factor_id').references(() => evalFactor.id),
  order: integer('order').notNull(),
});

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
  managementUnitId: integer('management_unit_id').notNull(), // TODO
});

export const strategicMap = schema.table('strategic_map', {
  id: serial('id').primaryKey().notNull(),
  managementUnitId: integer('management_unit_id').notNull(), // TODO
  description: text('description'),
});

export const businessMap = schema.table('business_map', {
  id: serial('id').primaryKey().notNull(),
  managementUnitId: integer('management_unit_id').notNull(), // TODO
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
});

export const fcsMatrix = schema.table('fcs_matrix', {
  id: serial('id').primaryKey().notNull(),
  managementUnitId: integer('management_unit_id').notNull(), // TODO
  strategicMapObjectiveId: integer('strategic_map_objective_id').notNull(), // TODO
  evalFactorId: integer('eval_factor_id').notNull().references(() => evalFactor.id),
});

export const fcsMatrixFactor = schema.table('fcs_matrix_factor', {
  id: serial('id').primaryKey().notNull(),
  fcsMatrixId: integer('fcs_matrix_id').notNull().references(() => fcsMatrix.id),
  description: varchar('description', {length: 160}).notNull(),
});

export const fcsMatrixInitiative = schema.table('fcs_matrix_initiative', {
  id: serial('id').primaryKey().notNull(),
  fcsMatrixId: integer('fcs_matrix_id').notNull().references(() => fcsMatrix.id),
  description: varchar('description', {length: 160}).notNull(),
  priority: boolean().notNull(),
});

export const fcsMatrixInitiativeFactor = schema.table('fcs_matrix_initiative_factor', {
  id: serial('id').primaryKey().notNull(),
  fcsMatrixId: integer('fcs_matrix_id').notNull().references(() => fcsMatrix.id),
  fcsMatrixFactorId: integer('fcs_matrix_factor_id').notNull().references(() => fcsMatrixInitiative.id),
  evalFactorItemId: integer('eval_factor_item_id').notNull().references(() => evalFactorItem.id),
});

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

export const strategicMapObjective = schema.table('strategic_map_objective', {
  id: serial('id').primaryKey().notNull(),
  strategicMapPerspectiveId: integer('strategic_map_perspective_id').notNull(), // TODO
  strategicObjectiveId: integer('strategic_objective_id').notNull(), // TODO
});

export const occurrence = schema.table('occurrence', {
  id: serial('id').primaryKey().notNull(),
  description: text('description'),
  occurrenceDate: date('occurrence_date').notNull(),
  status: varchar('status', {length: 160}),
  managementUnitId: integer('management_unit_id').notNull(), // TODO
  reporterId: integer('reporter_id'), // TODO
  repeatedIncident: boolean('repeated_incident'),
  immediateCountermeasures: text('immediate_countermeasures'),
  number: integer('number').notNull(), // TODO
});

export const filterIndicatorPanel = schema.table('filter_indicator_panel', {
  id: serial('id').primaryKey().notNull(),
  managementUnitId: integer('management_unit_id').notNull(), // TODO
  strategicMapObjectiveId: integer('strategic_map_objetive_id').notNull().references(() => strategicMapObjective.id),
});

export const roles = schema.table('roles', {
  id: serial('id').primaryKey().notNull(),
  name: varchar('name', {length: 128}).notNull(),
});

export const systemParams = schema.table('system_params', {
  id: serial('id').primaryKey().notNull(),
  smtpServer: varchar('smtp_server', {length: 160}).notNull(),
  smtpPort: integer('smtp_port').notNull(),
  smtpAuthRequired: boolean('smtp_auth_required').notNull(),
  smtpSslRequired: boolean('smtp_ssl_required').notNull(),
  smtpUser: varchar('smtp_user', {length: 160}).notNull(),
  smtpPassword: bytea('smtp_password'),
  smtpSender: varchar('smtp_sender', {length: 160}).notNull(),
  logoId: uuid('logo_id').notNull().references(() => files.id),
  reportLogoId: uuid('report_logo_id').notNull().references(() => files.id),
  notifyInvolvedUsersAnomaly: boolean('notify_involved_users_anomaly').notNull(), 
  timerCreateIndicatorTarget: integer('timer_create_indicator_target').notNull(),
  timerRealValuesUpdate: integer('timer_real_values_update').notNull(),
  timerAnomalyFixReminder: integer('timeranomaly_fix_reminder').notNull(),
  timerAnomalyFixLock: integer('timeranomaly_fix_lock').notNull(),
  timerAnomalyFixClosure: integer('timeranomaly_fix_closure').notNull(),
});

export const permissions = schema.table('permissions', {
  id: serial('id').primaryKey().notNull(),
  roleId: integer('role_id').notNull().references(() => roles.id),
  pageId: integer('page_id').notNull(), // TODO
  type: permissonType('type').notNull(),
});

export const perspective = schema.table('perspective', {
  id: serial('id').primaryKey().notNull(),
  description: varchar('description', {length: 160}).notNull(),
});

export const strategicMapPerspective = schema.table('strategic_map_perspective', {
  id: serial('id').primaryKey().notNull(),
  strategicMapId: integer('strategic_map_id').notNull().references(() => strategicMap.id),
  perspectiveId: integer('perspective_id').notNull().references(() => perspective.id),
  order: integer('order').notNull(),
});

export const actionPlan = schema.table('action_plan', {
  id: serial('id').primaryKey().notNull(),
  description: text('description').notNull(),
  descriptionHow: text('description_how'),
  descriptionWhy: text('description_why'),
  descriptionWho: text('description_who'),
  anomalyId: integer('anomaly_id').references(() => anomaly.id),
  planDate: date('plan_date'),
  status: integer('status'), // TODO
  statusUpdateDate: date('status_update_date'),
  preventiveActionId: integer('preventive_action_id').references(() => preventiveAction.id),
  managementUnitId: integer('management_unit_id').notNull(), // TODO
  initiativeId: integer('initiative_id').references(() => initiative.id),
  userId: integer('user_id'), // TODO
  amountP: integer('amount_p'),
  amountR: integer('amount_r'),
  measurementDescription: text(),
});

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
  normId: integer('norm_id').notNull().references(() => norm.id),
  index: varchar('index', {length: 20}).notNull(),
});

export const indicatorCancelRequests = schema.table('indicator_cancel_requests', {
  id: serial('id').primaryKey().notNull(),
  status: integer('status').notNull(), // TODO
  indicatorId: integer('indicator_id').notNull().references(() => indicator.id),
  userId: integer('user_id'), // TODO
  cancelReason: text('cancel_reason'),
  response: text('response'),
  requestedAt: date('requested_at').notNull(),
  commentId: integer('comment_id').references(() => comment.id),
});

export const indicatorRenegotiationRequests = schema.table('indicator_renegotiation_requests', {
  id: serial('id').primaryKey().notNull(),
  status: integer('status').notNull(), // TODO
  indicatorId: integer('indicator_id').notNull().references(() => indicator.id),
  userId: integer('user_id'), // TODO
  cancelReason: text('cancel_reason'),
  response: text('response'),
  requestedAt: date('requested_at').notNull(),
  commentId: integer('comment_id').references(() => comment.id),
});

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
});

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
  profilePhotoId: uuid('profile_photo_id').references(() => files.id),
  userRole: integer('userRole'), // TODO
  extension: varchar('extension', {length: 8}),
  banned: boolean('blocked').notNull(),
});

export const internalAuditUser = schema.table('internal_audit_user', {
  id: serial('id').primaryKey().notNull(),
  internalAuditId: integer('internal_audit_id').notNull().references(() => internalAudit.id),
  userName: varchar('user_name', {length: 48}).notNull(),
  position: varchar('position', {length: 128}).notNull(), // TODO
  userRole: integer('userRole'), // TODO
});


