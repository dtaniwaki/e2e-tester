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

ActiveRecord::Schema.define(version: 20160414022427) do

  create_table "active_admin_comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "namespace"
    t.text     "body",          limit: 65535
    t.string   "resource_id",                 null: false
    t.string   "resource_type",               null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",              default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "token"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree

  create_table "browser_browser_sets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "browser_id",     null: false
    t.integer  "browser_set_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "browser_browser_sets", ["browser_id"], name: "index_browser_browser_sets_on_browser_id", using: :btree
  add_index "browser_browser_sets", ["browser_set_id", "browser_id"], name: "index_browser_browser_sets_on_browser_set_id_and_browser_id", unique: true, using: :btree
  add_index "browser_browser_sets", ["browser_set_id"], name: "index_browser_browser_sets_on_browser_set_id", using: :btree

  create_table "browser_sets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                       null: false
    t.boolean  "disabled",   default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "browser_sets", ["name"], name: "index_browser_sets_on_name", using: :btree

  create_table "browsers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "type"
    t.string   "device"
    t.string   "os"
    t.string   "os_version"
    t.string   "browser"
    t.string   "browser_version"
    t.string   "name"
    t.boolean  "disabled",        default: false, null: false
    t.boolean  "deprecated",      default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "browsers", ["device", "os", "os_version", "browser", "browser_version"], name: "index_browser_types", length: {"device"=>32, "os"=>32, "os_version"=>32, "browser"=>32, "browser_version"=>32}, using: :btree
  add_index "browsers", ["disabled", "deprecated"], name: "index_browsers_on_disabled_and_deprecated", using: :btree
  add_index "browsers", ["type"], name: "index_browsers_on_type", using: :btree

  create_table "page_sources", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "test_step_id",           null: false
    t.integer  "test_step_execution_id", null: false
    t.string   "source_file_name"
    t.string   "source_content_type"
    t.integer  "source_file_size"
    t.datetime "source_updated_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "page_sources", ["test_step_execution_id"], name: "index_page_sources_on_test_step_execution_id", using: :btree
  add_index "page_sources", ["test_step_id", "test_step_execution_id"], name: "index_test_step_id_and_test_step_execution_id", unique: true, using: :btree
  add_index "page_sources", ["test_step_id"], name: "index_page_sources_on_test_step_id", using: :btree

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "title",      null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "projects", ["deleted_at"], name: "index_projects_on_deleted_at", using: :btree
  add_index "projects", ["title"], name: "index_projects_on_title", using: :btree
  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "screenshots", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "test_step_id",           null: false
    t.integer  "test_step_execution_id", null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "screenshots", ["test_step_execution_id"], name: "index_screenshots_on_test_step_execution_id", using: :btree
  add_index "screenshots", ["test_step_id", "test_step_execution_id"], name: "index_test_step_id_and_test_step_execution_id", unique: true, using: :btree
  add_index "screenshots", ["test_step_id"], name: "index_screenshots_on_test_step_id", using: :btree

  create_table "test_browsers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "test_id",    null: false
    t.integer  "browser_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "test_browsers", ["browser_id"], name: "index_test_browsers_on_browser_id", using: :btree
  add_index "test_browsers", ["test_id", "browser_id"], name: "index_test_browsers_on_test_id_and_browser_id", unique: true, using: :btree
  add_index "test_browsers", ["test_id"], name: "index_test_browsers_on_test_id", using: :btree

  create_table "test_execution_browsers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "test_execution_id",             null: false
    t.integer  "test_browser_id",               null: false
    t.integer  "state",             default: 0, null: false
    t.string   "error"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "test_execution_browsers", ["test_browser_id"], name: "index_test_execution_browsers_on_test_browser_id", using: :btree
  add_index "test_execution_browsers", ["test_execution_id", "test_browser_id"], name: "index_test_execution_id_and_test_browser_id", unique: true, using: :btree
  add_index "test_execution_browsers", ["test_execution_id"], name: "index_test_execution_browsers_on_test_execution_id", using: :btree

  create_table "test_executions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",                null: false
    t.integer  "test_id",                null: false
    t.integer  "state",      default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "test_executions", ["test_id"], name: "index_test_executions_on_test_id", using: :btree
  add_index "test_executions", ["user_id", "test_id"], name: "index_test_executions_on_user_id_and_test_id", using: :btree
  add_index "test_executions", ["user_id"], name: "index_test_executions_on_user_id", using: :btree

  create_table "test_step_executions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "test_step_id",                                        null: false
    t.integer  "test_execution_browser_id",                           null: false
    t.integer  "state",                                   default: 0, null: false
    t.text     "message",                   limit: 65535
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  add_index "test_step_executions", ["test_execution_browser_id"], name: "index_test_step_executions_on_test_execution_browser_id", using: :btree
  add_index "test_step_executions", ["test_step_id", "test_execution_browser_id"], name: "index_test_step_id_and_test_execution_browser_id", unique: true, using: :btree
  add_index "test_step_executions", ["test_step_id"], name: "index_test_step_executions_on_test_step_id", using: :btree

  create_table "test_step_sets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "project_id"
    t.integer  "test_step_set_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "user_id",          null: false
    t.string   "title"
    t.string   "type",             null: false
    t.datetime "deleted_at"
  end

  add_index "test_step_sets", ["project_id"], name: "index_test_step_sets_on_project_id", using: :btree
  add_index "test_step_sets", ["test_step_set_id"], name: "index_test_step_sets_on_test_step_set_id", using: :btree
  add_index "test_step_sets", ["user_id"], name: "index_test_step_sets_on_user_id", using: :btree

  create_table "test_steps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "type",                           null: false
    t.integer  "test_step_set_id",               null: false
    t.integer  "position"
    t.text     "data",             limit: 65535
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "test_steps", ["position"], name: "index_test_steps_on_position", using: :btree
  add_index "test_steps", ["test_step_set_id"], name: "index_test_steps_on_test_step_set_id", using: :btree
  add_index "test_steps", ["type"], name: "index_test_steps_on_type", using: :btree

  create_table "user_project_variables", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_project_id",             null: false
    t.string   "name",            limit: 128, null: false
    t.string   "value"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "user_project_variables", ["user_project_id", "name"], name: "index_user_project_variables_on_user_project_id_and_name", unique: true, using: :btree
  add_index "user_project_variables", ["user_project_id"], name: "index_user_project_variables_on_user_project_id", using: :btree

  create_table "user_projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",        null: false
    t.integer  "assigned_by_id"
    t.integer  "project_id",     null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "user_projects", ["assigned_by_id"], name: "index_user_projects_on_assigned_by_id", using: :btree
  add_index "user_projects", ["project_id"], name: "index_user_projects_on_project_id", using: :btree
  add_index "user_projects", ["user_id", "project_id"], name: "index_user_projects_on_user_id_and_project_id", unique: true, using: :btree
  add_index "user_projects", ["user_id"], name: "index_user_projects_on_user_id", using: :btree

  create_table "user_test_variables", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_test_id",             null: false
    t.string   "name",         limit: 128, null: false
    t.string   "value"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "user_test_variables", ["user_test_id", "name"], name: "index_user_test_variables_on_user_test_id_and_name", unique: true, using: :btree
  add_index "user_test_variables", ["user_test_id"], name: "index_user_test_variables_on_user_test_id", using: :btree

  create_table "user_tests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",        null: false
    t.integer  "assigned_by_id"
    t.integer  "test_id",        null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "user_tests", ["assigned_by_id"], name: "index_user_tests_on_assigned_by_id", using: :btree
  add_index "user_tests", ["test_id"], name: "index_user_tests_on_test_id", using: :btree
  add_index "user_tests", ["user_id", "test_id"], name: "index_user_tests_on_user_id_and_test_id", unique: true, using: :btree
  add_index "user_tests", ["user_id"], name: "index_user_tests_on_user_id", using: :btree

  create_table "user_variables", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",                null: false
    t.string   "name",       limit: 128, null: false
    t.string   "value"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "user_variables", ["user_id", "name"], name: "index_user_variables_on_user_id_and_name", unique: true, using: :btree
  add_index "user_variables", ["user_id"], name: "index_user_variables_on_user_id", using: :btree

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                   default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "remember_created_at"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.datetime "deleted_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  add_foreign_key "page_sources", "test_step_executions"
  add_foreign_key "page_sources", "test_steps"
  add_foreign_key "projects", "users"
  add_foreign_key "screenshots", "test_step_executions"
  add_foreign_key "screenshots", "test_steps"
  add_foreign_key "test_browsers", "browsers"
  add_foreign_key "test_browsers", "test_step_sets", column: "test_id"
  add_foreign_key "test_execution_browsers", "test_browsers"
  add_foreign_key "test_execution_browsers", "test_executions"
  add_foreign_key "test_executions", "test_step_sets", column: "test_id"
  add_foreign_key "test_executions", "users"
  add_foreign_key "test_step_executions", "test_execution_browsers"
  add_foreign_key "test_step_executions", "test_steps"
  add_foreign_key "test_step_sets", "projects"
  add_foreign_key "test_step_sets", "test_step_sets"
  add_foreign_key "test_step_sets", "users"
  add_foreign_key "test_steps", "test_step_sets"
  add_foreign_key "user_project_variables", "user_projects"
  add_foreign_key "user_projects", "projects"
  add_foreign_key "user_projects", "users"
  add_foreign_key "user_projects", "users", column: "assigned_by_id"
  add_foreign_key "user_test_variables", "user_tests"
  add_foreign_key "user_tests", "test_step_sets", column: "test_id"
  add_foreign_key "user_tests", "users"
  add_foreign_key "user_tests", "users", column: "assigned_by_id"
  add_foreign_key "user_variables", "users"
end
