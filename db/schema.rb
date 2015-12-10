# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151210225719) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "document_grades", force: :cascade do |t|
    t.integer  "document_id", null: false
    t.integer  "grade_id",    null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "document_grades", ["document_id", "grade_id"], name: "idx_doc_grd_uniq", unique: true, using: :btree
  add_index "document_grades", ["document_id"], name: "index_document_grades_on_document_id", using: :btree
  add_index "document_grades", ["grade_id"], name: "index_document_grades_on_grade_id", using: :btree

  create_table "document_identities", force: :cascade do |t|
    t.integer  "document_id",      null: false
    t.integer  "identity_id",      null: false
    t.integer  "identity_type_id", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "document_identities", ["document_id", "identity_id", "identity_type_id"], name: "idx_doc_idt_uniq", unique: true, using: :btree
  add_index "document_identities", ["document_id"], name: "index_document_identities_on_document_id", using: :btree
  add_index "document_identities", ["identity_id"], name: "index_document_identities_on_identity_id", using: :btree
  add_index "document_identities", ["identity_type_id"], name: "index_document_identities_on_identity_type_id", using: :btree

  create_table "document_import_rows", force: :cascade do |t|
    t.integer  "document_import_id", null: false
    t.jsonb    "import_errors"
    t.jsonb    "content",            null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.jsonb    "mappings"
    t.jsonb    "prepare_errors"
    t.jsonb    "mapping_errors"
  end

  add_index "document_import_rows", ["document_import_id"], name: "index_document_import_rows_on_document_import_id", using: :btree

  create_table "document_imports", force: :cascade do |t|
    t.integer  "prepare_jid"
    t.integer  "import_jid"
    t.string   "file",          null: false
    t.integer  "repository_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "prepared_at"
    t.datetime "imported_at"
    t.integer  "mappings_jid"
    t.datetime "mapped_at"
  end

  add_index "document_imports", ["repository_id"], name: "index_document_imports_on_repository_id", using: :btree

  create_table "document_languages", force: :cascade do |t|
    t.integer  "document_id", null: false
    t.integer  "language_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "document_languages", ["document_id", "language_id"], name: "index_document_languages_on_document_id_and_language_id", unique: true, using: :btree
  add_index "document_languages", ["document_id"], name: "index_document_languages_on_document_id", using: :btree
  add_index "document_languages", ["language_id"], name: "index_document_languages_on_language_id", using: :btree

  create_table "document_resource_types", force: :cascade do |t|
    t.integer  "document_id",      null: false
    t.integer  "resource_type_id", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "document_resource_types", ["document_id", "resource_type_id"], name: "idx_doc_res_typ_uniq", unique: true, using: :btree
  add_index "document_resource_types", ["document_id"], name: "index_document_resource_types_on_document_id", using: :btree
  add_index "document_resource_types", ["resource_type_id"], name: "index_document_resource_types_on_resource_type_id", using: :btree

  create_table "document_standards", force: :cascade do |t|
    t.integer  "document_id", null: false
    t.integer  "standard_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "document_standards", ["document_id", "standard_id"], name: "idx_doc_std_uniq", unique: true, using: :btree
  add_index "document_standards", ["document_id"], name: "index_document_standards_on_document_id", using: :btree
  add_index "document_standards", ["standard_id"], name: "index_document_standards_on_standard_id", using: :btree

  create_table "document_statuses", force: :cascade do |t|
    t.string   "value",       null: false
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "document_statuses", ["value"], name: "index_document_statuses_on_value", unique: true, using: :btree

  create_table "document_subjects", force: :cascade do |t|
    t.integer  "document_id", null: false
    t.integer  "subject_id",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "document_subjects", ["document_id", "subject_id"], name: "idx_doc_subject_uniq", unique: true, using: :btree
  add_index "document_subjects", ["document_id"], name: "index_document_subjects_on_document_id", using: :btree
  add_index "document_subjects", ["subject_id"], name: "index_document_subjects_on_subject_id", using: :btree

  create_table "documents", force: :cascade do |t|
    t.integer  "url_id",             null: false
    t.integer  "repository_id",      null: false
    t.integer  "document_status_id", null: false
    t.text     "title",              null: false
    t.text     "description"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "documents", ["document_status_id"], name: "index_documents_on_document_status_id", using: :btree
  add_index "documents", ["repository_id", "url_id"], name: "index_documents_on_repository_id_and_url_id", unique: true, using: :btree
  add_index "documents", ["repository_id"], name: "index_documents_on_repository_id", using: :btree
  add_index "documents", ["url_id"], name: "index_documents_on_url_id", using: :btree

  create_table "grade_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "grade_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "grade_anc_desc_idx", unique: true, using: :btree
  add_index "grade_hierarchies", ["descendant_id"], name: "grade_desc_idx", using: :btree

  create_table "grades", force: :cascade do |t|
    t.string   "value",            null: false
    t.integer  "parent_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "review_status_id", null: false
  end

  add_index "grades", ["review_status_id"], name: "index_grades_on_review_status_id", using: :btree
  add_index "grades", ["value", "parent_id"], name: "index_grades_on_value_and_parent_id", unique: true, using: :btree

  create_table "identities", force: :cascade do |t|
    t.string   "value",            null: false
    t.string   "name",             null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "review_status_id", null: false
  end

  add_index "identities", ["review_status_id"], name: "index_identities_on_review_status_id", using: :btree
  add_index "identities", ["value"], name: "index_identities_on_value", unique: true, using: :btree

  create_table "identity_types", force: :cascade do |t|
    t.string   "value",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "identity_types", ["value"], name: "index_identity_types_on_value", unique: true, using: :btree

  create_table "languages", force: :cascade do |t|
    t.string   "value",            null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "review_status_id", null: false
  end

  add_index "languages", ["review_status_id"], name: "index_languages_on_review_status_id", using: :btree
  add_index "languages", ["value"], name: "index_languages_on_value", unique: true, using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "value",      null: false
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "organizations", ["value"], name: "index_organizations_on_value", unique: true, using: :btree

  create_table "repositories", force: :cascade do |t|
    t.string   "value",           null: false
    t.string   "name",            null: false
    t.integer  "organization_id", null: false
    t.boolean  "public",          null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "repositories", ["organization_id"], name: "index_repositories_on_organization_id", using: :btree
  add_index "repositories", ["value", "organization_id"], name: "index_repositories_on_value_and_organization_id", unique: true, using: :btree
  add_index "repositories", ["value"], name: "index_repositories_on_value", using: :btree

  create_table "resource_type_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "resource_type_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "resource_type_anc_desc_idx", unique: true, using: :btree
  add_index "resource_type_hierarchies", ["descendant_id"], name: "resource_type_desc_idx", using: :btree

  create_table "resource_types", force: :cascade do |t|
    t.string   "value",            null: false
    t.integer  "parent_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "review_status_id", null: false
  end

  add_index "resource_types", ["review_status_id"], name: "index_resource_types_on_review_status_id", using: :btree
  add_index "resource_types", ["value", "parent_id"], name: "index_resource_types_on_value_and_parent_id", unique: true, using: :btree

  create_table "review_statuses", force: :cascade do |t|
    t.string "value",       null: false
    t.string "description"
  end

  add_index "review_statuses", ["value"], name: "index_review_statuses_on_value", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "standard_frameworks", force: :cascade do |t|
    t.string   "value",      null: false
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "standard_frameworks", ["value"], name: "index_standard_frameworks_on_value", unique: true, using: :btree

  create_table "standard_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "standard_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "standard_anc_desc_idx", unique: true, using: :btree
  add_index "standard_hierarchies", ["descendant_id"], name: "standard_desc_idx", using: :btree

  create_table "standards", force: :cascade do |t|
    t.string   "value",                 null: false
    t.integer  "parent_id"
    t.string   "name",                  null: false
    t.integer  "standard_framework_id", null: false
    t.string   "url"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "review_status_id",      null: false
  end

  add_index "standards", ["review_status_id"], name: "index_standards_on_review_status_id", using: :btree
  add_index "standards", ["standard_framework_id"], name: "index_standards_on_standard_framework_id", using: :btree
  add_index "standards", ["value", "parent_id"], name: "index_standards_on_value_and_parent_id", unique: true, using: :btree

  create_table "subject_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "subject_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "subject_anc_desc_idx", unique: true, using: :btree
  add_index "subject_hierarchies", ["descendant_id"], name: "subject_desc_idx", using: :btree

  create_table "subjects", force: :cascade do |t|
    t.string   "value",            null: false
    t.integer  "parent_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "review_status_id", null: false
  end

  add_index "subjects", ["review_status_id"], name: "index_subjects_on_review_status_id", using: :btree
  add_index "subjects", ["value", "parent_id"], name: "index_subjects_on_value_and_parent_id", unique: true, using: :btree

  create_table "url_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "url_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "url_anc_desc_idx", unique: true, using: :btree
  add_index "url_hierarchies", ["descendant_id"], name: "url_desc_idx", using: :btree

  create_table "urls", force: :cascade do |t|
    t.string   "url",         null: false
    t.integer  "parent_id"
    t.integer  "last_status"
    t.datetime "checked_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "urls", ["parent_id"], name: "index_urls_on_parent_id", using: :btree
  add_index "urls", ["url"], name: "index_urls_on_url", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  add_foreign_key "document_grades", "documents"
  add_foreign_key "document_grades", "grades"
  add_foreign_key "document_identities", "documents"
  add_foreign_key "document_identities", "identities"
  add_foreign_key "document_identities", "identity_types"
  add_foreign_key "document_import_rows", "document_imports"
  add_foreign_key "document_imports", "repositories"
  add_foreign_key "document_languages", "documents"
  add_foreign_key "document_languages", "languages"
  add_foreign_key "document_resource_types", "documents"
  add_foreign_key "document_resource_types", "resource_types"
  add_foreign_key "document_standards", "documents"
  add_foreign_key "document_standards", "standards"
  add_foreign_key "document_subjects", "documents"
  add_foreign_key "document_subjects", "subjects"
  add_foreign_key "documents", "document_statuses"
  add_foreign_key "documents", "repositories"
  add_foreign_key "documents", "urls"
  add_foreign_key "grades", "grades", column: "parent_id"
  add_foreign_key "grades", "review_statuses"
  add_foreign_key "identities", "review_statuses"
  add_foreign_key "languages", "review_statuses"
  add_foreign_key "repositories", "organizations"
  add_foreign_key "resource_types", "resource_types", column: "parent_id"
  add_foreign_key "resource_types", "review_statuses"
  add_foreign_key "standards", "review_statuses"
  add_foreign_key "standards", "standard_frameworks"
  add_foreign_key "standards", "standards", column: "parent_id"
  add_foreign_key "subjects", "review_statuses"
  add_foreign_key "subjects", "subjects", column: "parent_id"
  add_foreign_key "urls", "urls", column: "parent_id"
end
