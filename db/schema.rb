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

ActiveRecord::Schema.define(version: 20180214214343) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.bigint "question_id"
    t.text "text"
    t.boolean "correct"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "certificate_templates", force: :cascade do |t|
    t.string "filename"
    t.string "owner_type"
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pdf_file_name"
    t.string "pdf_content_type"
    t.integer "pdf_file_size"
    t.datetime "pdf_updated_at"
    t.index ["owner_type", "owner_id"], name: "index_certificate_templates_on_owner_type_and_owner_id"
  end

  create_table "certificates", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pdf_file_name"
    t.string "pdf_content_type"
    t.integer "pdf_file_size"
    t.datetime "pdf_updated_at"
    t.index ["course_id"], name: "index_certificates_on_course_id"
    t.index ["user_id"], name: "index_certificates_on_user_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.bigint "organization_id"
    t.bigint "certificate_template_id"
    t.float "average_rating", default: 0.0
    t.integer "visibility", default: 0
    t.integer "passing_courses_count", default: 0
    t.integer "finished_successfully_count", default: 0
    t.integer "finished_unsuccessfully_count", default: 0
    t.integer "passing_by_organization_users_percent", default: 0
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["certificate_template_id"], name: "index_courses_on_certificate_template_id"
    t.index ["organization_id"], name: "index_courses_on_organization_id"
    t.index ["user_id"], name: "index_courses_on_user_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_favorites_on_course_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "impersonations", force: :cascade do |t|
    t.bigint "impersonator_id"
    t.bigint "target_user_id"
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["impersonator_id"], name: "index_impersonations_on_impersonator_id"
    t.index ["target_user_id"], name: "index_impersonations_on_target_user_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.string "user_email"
    t.boolean "user_persisted", default: false
    t.boolean "accepted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.index ["organization_id"], name: "index_invitations_on_organization_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "sphere"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "pages", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_pages_on_course_id"
  end

  create_table "passing_courses", force: :cascade do |t|
    t.bigint "course_id"
    t.bigint "user_id"
    t.integer "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "active_page", default: 0
    t.integer "status", default: 0
    t.decimal "progress", precision: 5, scale: 2
    t.index ["course_id"], name: "index_passing_courses_on_course_id"
    t.index ["user_id"], name: "index_passing_courses_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "page_id"
    t.string "question_type"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_questions_on_page_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "course_id"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_ratings_on_course_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "receipts", force: :cascade do |t|
    t.bigint "message_id"
    t.bigint "owner_id"
    t.string "box"
    t.boolean "viewed", default: false
    t.boolean "trashed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_receipts_on_message_id"
    t.index ["owner_id"], name: "index_receipts_on_owner_id"
  end

  create_table "requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_requests_on_organization_id"
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "review_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "user_answer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_answer_id"], name: "index_review_requests_on_user_answer_id"
    t.index ["user_id"], name: "index_review_requests_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.bigint "user_id"
    t.index ["organization_id"], name: "index_roles_on_organization_id"
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "selected_course_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_selected_course_users_on_course_id"
    t.index ["user_id"], name: "index_selected_course_users_on_user_id"
  end

  create_table "user_answers", force: :cascade do |t|
    t.bigint "passing_course_id"
    t.bigint "question_id"
    t.bigint "answer_id"
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["answer_id"], name: "index_user_answers_on_answer_id"
    t.index ["passing_course_id"], name: "index_user_answers_on_passing_course_id"
    t.index ["question_id"], name: "index_user_answers_on_question_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "reset_password_token"
    t.string "encrypted_password", default: "", null: false
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["nickname"], name: "index_users_on_nickname", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "certificates", "courses"
  add_foreign_key "certificates", "users"
  add_foreign_key "courses", "certificate_templates"
  add_foreign_key "courses", "users"
  add_foreign_key "favorites", "courses"
  add_foreign_key "favorites", "users"
  add_foreign_key "invitations", "organizations"
  add_foreign_key "pages", "courses"
  add_foreign_key "passing_courses", "courses"
  add_foreign_key "passing_courses", "users"
  add_foreign_key "questions", "pages"
  add_foreign_key "ratings", "courses"
  add_foreign_key "ratings", "users"
  add_foreign_key "requests", "organizations"
  add_foreign_key "requests", "users"
  add_foreign_key "review_requests", "user_answers"
  add_foreign_key "review_requests", "users"
  add_foreign_key "roles", "organizations"
  add_foreign_key "roles", "users"
  add_foreign_key "selected_course_users", "courses"
  add_foreign_key "selected_course_users", "users"
  add_foreign_key "user_answers", "answers"
  add_foreign_key "user_answers", "passing_courses"
  add_foreign_key "user_answers", "questions"
end
