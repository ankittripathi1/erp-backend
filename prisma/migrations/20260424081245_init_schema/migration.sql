-- CreateTable
CREATE TABLE "academic_academicterm" (
    "id" BIGSERIAL NOT NULL,
    "academic_year_id" BIGINT NOT NULL,
    "name" TEXT NOT NULL,
    "term_type" TEXT NOT NULL,
    "start_date" TIMESTAMP(3),
    "end_date" TIMESTAMP(3),
    "is_current" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "academic_academicterm_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "academic_academicyear" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "start_date" TIMESTAMP(3) NOT NULL,
    "end_date" TIMESTAMP(3) NOT NULL,
    "is_current" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "academic_academicyear_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "academic_batch" (
    "id" BIGSERIAL NOT NULL,
    "program_id" BIGINT NOT NULL,
    "name" TEXT NOT NULL,
    "start_year" INTEGER NOT NULL,
    "end_year" INTEGER NOT NULL,
    "max_strength" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "academic_batch_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "academic_program" (
    "id" BIGSERIAL NOT NULL,
    "department_id" BIGINT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "level" TEXT NOT NULL,
    "duration_years" DECIMAL(65,30) NOT NULL,
    "total_terms" INTEGER NOT NULL,
    "total_credits" INTEGER,
    "grading_scheme_id" BIGINT,
    "description" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "academic_program_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "academic_section" (
    "id" BIGSERIAL NOT NULL,
    "batch_id" BIGINT NOT NULL,
    "term_id" BIGINT NOT NULL,
    "name" TEXT NOT NULL,
    "class_teacher_id" BIGINT,
    "max_strength" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "academic_section_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "accounting_accountgroup" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "parent_id" BIGINT,
    "root_type" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "accounting_accountgroup_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "accounting_chartofaccount" (
    "id" BIGSERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "group_id" BIGINT NOT NULL,
    "account_type" TEXT NOT NULL,
    "currency_id" BIGINT,
    "is_bank" BOOLEAN NOT NULL DEFAULT false,
    "opening_balance" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "accounting_chartofaccount_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "accounting_fiscalyear" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "start_date" TIMESTAMP(3) NOT NULL,
    "end_date" TIMESTAMP(3) NOT NULL,
    "is_closed" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "accounting_fiscalyear_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "accounting_journalentry" (
    "id" BIGSERIAL NOT NULL,
    "entry_no" TEXT NOT NULL,
    "fiscal_year_id" BIGINT NOT NULL,
    "posting_date" TIMESTAMP(3) NOT NULL,
    "narration" TEXT NOT NULL DEFAULT '',
    "source_type" TEXT NOT NULL,
    "source_id" BIGINT,
    "status" TEXT NOT NULL,
    "posted_by_id" BIGINT,
    "posted_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "accounting_journalentry_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "accounting_journalline" (
    "id" BIGSERIAL NOT NULL,
    "entry_id" BIGINT NOT NULL,
    "account_id" BIGINT NOT NULL,
    "debit" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "credit" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "party_content_type_id" BIGINT,
    "party_id" BIGINT,
    "party" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "accounting_journalline_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "alumni_alumni" (
    "id" BIGSERIAL NOT NULL,
    "user_id" BIGINT NOT NULL,
    "student_id" BIGINT,
    "program_id" BIGINT,
    "batch_id" BIGINT,
    "graduation_year" INTEGER NOT NULL,
    "current_company" TEXT NOT NULL DEFAULT '',
    "current_role" TEXT NOT NULL DEFAULT '',
    "linkedin_url" TEXT NOT NULL DEFAULT '',
    "location" TEXT NOT NULL DEFAULT '',
    "bio" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "alumni_alumni_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "alumni_alumnidonation" (
    "id" BIGSERIAL NOT NULL,
    "alumni_id" BIGINT NOT NULL,
    "amount" DECIMAL(65,30) NOT NULL,
    "purpose" TEXT NOT NULL DEFAULT '',
    "donated_on" TIMESTAMP(3) NOT NULL,
    "payment_mode" TEXT NOT NULL DEFAULT '',
    "txn_reference" TEXT NOT NULL DEFAULT '',
    "journal_entry_id" BIGINT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "alumni_alumnidonation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "alumni_alumnievent" (
    "id" BIGSERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "event_type" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "start_at" TIMESTAMP(3) NOT NULL,
    "end_at" TIMESTAMP(3),
    "venue" TEXT NOT NULL DEFAULT '',
    "is_online" BOOLEAN NOT NULL DEFAULT false,
    "meeting_link" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "alumni_alumnievent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "alumni_alumnieventattendee" (
    "id" BIGSERIAL NOT NULL,
    "event_id" BIGINT NOT NULL,
    "alumni_id" BIGINT NOT NULL,
    "registered_on" TIMESTAMP(3) NOT NULL,
    "attended" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "alumni_alumnieventattendee_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assets_asset" (
    "id" BIGSERIAL NOT NULL,
    "asset_tag" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "category_id" BIGINT NOT NULL,
    "vendor_id" BIGINT,
    "purchase_date" TIMESTAMP(3),
    "purchase_cost" DECIMAL(65,30),
    "serial_no" TEXT NOT NULL DEFAULT '',
    "location" TEXT NOT NULL DEFAULT '',
    "condition" TEXT NOT NULL,
    "warranty_until" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "assets_asset_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assets_assetassignment" (
    "id" BIGSERIAL NOT NULL,
    "asset_id" BIGINT NOT NULL,
    "assigned_content_type_id" BIGINT NOT NULL,
    "assigned_object_id" BIGINT NOT NULL,
    "assigned_to" TEXT NOT NULL,
    "assigned_on" TIMESTAMP(3) NOT NULL,
    "returned_on" TIMESTAMP(3),
    "remarks" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "assets_assetassignment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assets_assetcategory" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "depreciation_percent" DECIMAL(65,30),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "assets_assetcategory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assets_purchase" (
    "id" BIGSERIAL NOT NULL,
    "po_no" TEXT NOT NULL,
    "vendor_id" BIGINT NOT NULL,
    "purchase_date" TIMESTAMP(3) NOT NULL,
    "total_amount" DECIMAL(65,30) NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'draft',
    "journal_entry_id" BIGINT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "assets_purchase_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assets_purchaseitem" (
    "id" BIGSERIAL NOT NULL,
    "purchase_id" BIGINT NOT NULL,
    "description" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 1,
    "unit_price" DECIMAL(65,30) NOT NULL,
    "asset_id" BIGINT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "assets_purchaseitem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assets_vendor" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "gst_no" TEXT NOT NULL DEFAULT '',
    "contact_name" TEXT NOT NULL DEFAULT '',
    "contact_email" TEXT NOT NULL DEFAULT '',
    "contact_phone" TEXT NOT NULL DEFAULT '',
    "address" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "assets_vendor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_auditlog" (
    "id" BIGSERIAL NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL,
    "actor_id" BIGINT,
    "action" TEXT NOT NULL,
    "target_content_type_id" BIGINT,
    "target_id" BIGINT,
    "target" TEXT NOT NULL,
    "changes" JSONB,
    "user_agent" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "audit_auditlog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_setting" (
    "id" BIGSERIAL NOT NULL,
    "key" TEXT NOT NULL,
    "value" JSONB NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "audit_setting_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "communication_announcement" (
    "id" BIGSERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "body" TEXT NOT NULL,
    "audience" TEXT NOT NULL,
    "department_id" BIGINT,
    "program_id" BIGINT,
    "batch_id" BIGINT,
    "author_id" BIGINT,
    "published_at" TIMESTAMP(3),
    "expires_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "communication_announcement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "communication_event" (
    "id" BIGSERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "start_at" TIMESTAMP(3) NOT NULL,
    "end_at" TIMESTAMP(3),
    "venue" TEXT NOT NULL DEFAULT '',
    "organized_by" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "communication_event_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "communication_notification" (
    "id" BIGSERIAL NOT NULL,
    "recipient_id" BIGINT NOT NULL,
    "title" TEXT NOT NULL,
    "body" TEXT NOT NULL DEFAULT '',
    "channel" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "sent_at" TIMESTAMP(3),
    "read_at" TIMESTAMP(3),
    "url" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "communication_notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core_address" (
    "id" BIGSERIAL NOT NULL,
    "line1" TEXT NOT NULL,
    "line2" TEXT NOT NULL DEFAULT '',
    "city" TEXT NOT NULL,
    "state" TEXT NOT NULL DEFAULT '',
    "postal_code" TEXT NOT NULL DEFAULT '',
    "country" TEXT NOT NULL DEFAULT 'India',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "core_address_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core_currency" (
    "id" BIGSERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "symbol" TEXT NOT NULL DEFAULT '',
    "is_default" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "core_currency_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core_document" (
    "id" BIGSERIAL NOT NULL,
    "content_type_id" BIGINT NOT NULL,
    "object_id" BIGINT NOT NULL,
    "owner" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "doc_type" TEXT NOT NULL DEFAULT '',
    "file" TEXT NOT NULL,
    "uploaded_by_id" BIGINT,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "mime_type" TEXT NOT NULL DEFAULT '',
    "file_size" BIGINT,
    "verified_at" TIMESTAMP(3),
    "verified_by_id" BIGINT,
    "is_private" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "core_document_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core_emergencycontact" (
    "id" BIGSERIAL NOT NULL,
    "content_type_id" BIGINT NOT NULL,
    "object_id" BIGINT NOT NULL,
    "owner" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "relation" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "email" TEXT NOT NULL DEFAULT '',
    "address_id" BIGINT,
    "priority" INTEGER NOT NULL DEFAULT 1,
    "phone_verified" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "core_emergencycontact_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core_role" (
    "id" BIGSERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "core_role_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core_user" (
    "id" BIGSERIAL NOT NULL,
    "email" TEXT,
    "middle_name" TEXT NOT NULL DEFAULT '',
    "phone" TEXT NOT NULL DEFAULT '',
    "date_of_birth" TIMESTAMP(3),
    "gender" TEXT NOT NULL DEFAULT '',
    "blood_group" TEXT NOT NULL DEFAULT '',
    "profile_photo" TEXT,
    "user_type" TEXT NOT NULL,
    "account_status" TEXT NOT NULL,
    "email_verified" BOOLEAN NOT NULL DEFAULT false,
    "phone_verified" BOOLEAN NOT NULL DEFAULT false,
    "password_changed_at" TIMESTAMP(3),
    "last_failed_login_at" TIMESTAMP(3),
    "last_seen_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "core_user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core_useraddress" (
    "id" BIGSERIAL NOT NULL,
    "user_id" BIGINT NOT NULL,
    "address_id" BIGINT NOT NULL,
    "address_type" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "core_useraddress_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core_userrole" (
    "id" BIGSERIAL NOT NULL,
    "user_id" BIGINT NOT NULL,
    "role_id" BIGINT NOT NULL,
    "assigned_at" TIMESTAMP(3) NOT NULL,
    "assigned_by_id" BIGINT,
    "revoked_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "core_userrole_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "courses_course" (
    "id" BIGSERIAL NOT NULL,
    "department_id" BIGINT NOT NULL,
    "code" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "credits" DECIMAL(65,30) NOT NULL,
    "course_type" TEXT NOT NULL,
    "theory_hours" INTEGER NOT NULL DEFAULT 0,
    "practical_hours" INTEGER NOT NULL DEFAULT 0,
    "description" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "courses_course_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "courses_courseoffering" (
    "id" BIGSERIAL NOT NULL,
    "course_id" BIGINT NOT NULL,
    "term_id" BIGINT NOT NULL,
    "section_id" BIGINT,
    "primary_teacher_id" BIGINT,
    "room_id" BIGINT,
    "capacity" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "courses_courseoffering_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "courses_courseprerequisite" (
    "id" BIGSERIAL NOT NULL,
    "course_id" BIGINT NOT NULL,
    "prereq_course_id" BIGINT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "courses_courseprerequisite_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "courses_programcourse" (
    "id" BIGSERIAL NOT NULL,
    "program_id" BIGINT NOT NULL,
    "course_id" BIGINT NOT NULL,
    "term_number" INTEGER NOT NULL,
    "is_mandatory" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "courses_programcourse_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "courses_syllabustopic" (
    "id" BIGSERIAL NOT NULL,
    "course_id" BIGINT NOT NULL,
    "unit_number" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "expected_hours" DECIMAL(65,30),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "courses_syllabustopic_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "courses_teachingassignment" (
    "id" BIGSERIAL NOT NULL,
    "offering_id" BIGINT NOT NULL,
    "employee_id" BIGINT NOT NULL,
    "role" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "courses_teachingassignment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employees_designation" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "employees_designation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employees_employee" (
    "id" BIGSERIAL NOT NULL,
    "user_id" BIGINT NOT NULL,
    "employee_no" TEXT NOT NULL,
    "department_id" BIGINT,
    "designation_id" BIGINT NOT NULL,
    "reports_to_id" BIGINT,
    "employment_type" TEXT NOT NULL,
    "joining_date" TIMESTAMP(3) NOT NULL,
    "confirmation_date" TIMESTAMP(3),
    "exit_date" TIMESTAMP(3),
    "status" TEXT NOT NULL,
    "pan_no" TEXT NOT NULL DEFAULT '',
    "aadhaar_no" TEXT NOT NULL DEFAULT '',
    "pf_no" TEXT NOT NULL DEFAULT '',
    "uan_no" TEXT NOT NULL DEFAULT '',
    "bank_account_no" TEXT NOT NULL DEFAULT '',
    "bank_ifsc" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "employees_employee_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employees_qualification" (
    "id" BIGSERIAL NOT NULL,
    "employee_id" BIGINT NOT NULL,
    "degree" TEXT NOT NULL,
    "institution" TEXT NOT NULL,
    "year" INTEGER,
    "percentage" DECIMAL(65,30),
    "specialization" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "employees_qualification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employees_workexperience" (
    "id" BIGSERIAL NOT NULL,
    "employee_id" BIGINT NOT NULL,
    "company" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "start_date" TIMESTAMP(3),
    "end_date" TIMESTAMP(3),
    "description" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "employees_workexperience_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "exams_exam" (
    "id" BIGSERIAL NOT NULL,
    "term_id" BIGINT NOT NULL,
    "exam_type_id" BIGINT NOT NULL,
    "name" TEXT NOT NULL,
    "start_date" TIMESTAMP(3),
    "end_date" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "exams_exam_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "exams_examschedule" (
    "id" BIGSERIAL NOT NULL,
    "exam_id" BIGINT NOT NULL,
    "offering_id" BIGINT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "start_time" TIMESTAMP(3) NOT NULL,
    "end_time" TIMESTAMP(3) NOT NULL,
    "room_id" BIGINT,
    "max_marks" DECIMAL(65,30) NOT NULL,
    "min_passing" DECIMAL(65,30) NOT NULL,
    "weight" DECIMAL(65,30) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "exams_examschedule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "exams_examtype" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "exams_examtype_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "exams_studentcourseresult" (
    "id" BIGSERIAL NOT NULL,
    "enrollment_id" BIGINT NOT NULL,
    "total_percentage" DECIMAL(65,30) NOT NULL,
    "grade_band_id" BIGINT,
    "grade_letter" TEXT NOT NULL DEFAULT '',
    "grade_points" DECIMAL(65,30),
    "credits_earned" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "finalized_on" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "exams_studentcourseresult_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "exams_studentcumulativeresult" (
    "id" BIGSERIAL NOT NULL,
    "student_id" BIGINT NOT NULL,
    "cgpa" DECIMAL(65,30),
    "percentage" DECIMAL(65,30),
    "total_credits_earned" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "exams_studentcumulativeresult_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "exams_studentmark" (
    "id" BIGSERIAL NOT NULL,
    "schedule_id" BIGINT NOT NULL,
    "student_id" BIGINT NOT NULL,
    "marks_obtained" DECIMAL(65,30),
    "is_absent" BOOLEAN NOT NULL DEFAULT false,
    "remarks" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "exams_studentmark_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "exams_studenttermresult" (
    "id" BIGSERIAL NOT NULL,
    "student_id" BIGINT NOT NULL,
    "term_id" BIGINT NOT NULL,
    "sgpa" DECIMAL(65,30),
    "total_credits" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "percentage" DECIMAL(65,30),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "exams_studenttermresult_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fees_feecategory" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "fees_feecategory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fees_feehead" (
    "id" BIGSERIAL NOT NULL,
    "category_id" BIGINT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "fees_feehead_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fees_feeinvoice" (
    "id" BIGSERIAL NOT NULL,
    "invoice_no" TEXT NOT NULL,
    "student_id" BIGINT NOT NULL,
    "term_id" BIGINT NOT NULL,
    "issue_date" TIMESTAMP(3) NOT NULL,
    "due_date" TIMESTAMP(3) NOT NULL,
    "total_amount" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "discount_amount" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "paid_amount" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "balance_amount" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "status" TEXT NOT NULL,
    "journal_entry_id" BIGINT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "fees_feeinvoice_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fees_feeinvoiceline" (
    "id" BIGSERIAL NOT NULL,
    "invoice_id" BIGINT NOT NULL,
    "fee_head_id" BIGINT NOT NULL,
    "amount" DECIMAL(65,30) NOT NULL,
    "discount" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "fees_feeinvoiceline_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fees_feestructure" (
    "id" BIGSERIAL NOT NULL,
    "program_id" BIGINT NOT NULL,
    "batch_id" BIGINT,
    "term_id" BIGINT,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "fees_feestructure_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fees_feestructureitem" (
    "id" BIGSERIAL NOT NULL,
    "structure_id" BIGINT NOT NULL,
    "fee_head_id" BIGINT NOT NULL,
    "amount" DECIMAL(65,30) NOT NULL,
    "is_refundable" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "fees_feestructureitem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fees_payment" (
    "id" BIGSERIAL NOT NULL,
    "payment_no" TEXT NOT NULL,
    "invoice_id" BIGINT NOT NULL,
    "amount" DECIMAL(65,30) NOT NULL,
    "paid_on" TIMESTAMP(3) NOT NULL,
    "mode" TEXT NOT NULL,
    "txn_reference" TEXT NOT NULL DEFAULT '',
    "status" TEXT NOT NULL,
    "received_by_id" BIGINT,
    "journal_entry_id" BIGINT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "fees_payment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fees_refund" (
    "id" BIGSERIAL NOT NULL,
    "payment_id" BIGINT NOT NULL,
    "amount" DECIMAL(65,30) NOT NULL,
    "reason" TEXT NOT NULL DEFAULT '',
    "refunded_on" TIMESTAMP(3),
    "status" TEXT NOT NULL DEFAULT 'pending',
    "journal_entry_id" BIGINT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "fees_refund_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fees_scholarship" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "discount_type" TEXT NOT NULL,
    "value" DECIMAL(65,30) NOT NULL,
    "source" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "fees_scholarship_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fees_studentscholarship" (
    "id" BIGSERIAL NOT NULL,
    "student_id" BIGINT NOT NULL,
    "scholarship_id" BIGINT NOT NULL,
    "effective_from" TIMESTAMP(3) NOT NULL,
    "effective_to" TIMESTAMP(3),
    "approved_by_id" BIGINT,
    "status" TEXT NOT NULL DEFAULT 'active',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "fees_studentscholarship_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "grading_gradeband" (
    "id" BIGSERIAL NOT NULL,
    "scheme_id" BIGINT NOT NULL,
    "band_code" TEXT NOT NULL,
    "min_percentage" DECIMAL(65,30) NOT NULL,
    "max_percentage" DECIMAL(65,30) NOT NULL,
    "grade_points" DECIMAL(65,30),
    "is_pass" BOOLEAN NOT NULL DEFAULT true,
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "grading_gradeband_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "grading_gradeconversionrule" (
    "id" BIGSERIAL NOT NULL,
    "from_scheme_id" BIGINT NOT NULL,
    "to_scheme_id" BIGINT NOT NULL,
    "formula" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "grading_gradeconversionrule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "grading_gradingscheme" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "scheme_type" TEXT NOT NULL,
    "max_grade_points" DECIMAL(65,30),
    "pass_threshold" DECIMAL(65,30) NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "grading_gradingscheme_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hostel_hostel" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "campus_id" BIGINT NOT NULL,
    "hostel_type" TEXT NOT NULL,
    "warden_id" BIGINT,
    "total_capacity" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "hostel_hostel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hostel_hostelapplication" (
    "id" BIGSERIAL NOT NULL,
    "student_id" BIGINT NOT NULL,
    "preferred_hostel_id" BIGINT,
    "applied_on" TIMESTAMP(3) NOT NULL,
    "academic_year_id" BIGINT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'submitted',
    "remarks" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "hostel_hostelapplication_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hostel_hostelblock" (
    "id" BIGSERIAL NOT NULL,
    "hostel_id" BIGINT NOT NULL,
    "name" TEXT NOT NULL,
    "total_floors" INTEGER NOT NULL DEFAULT 1,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "hostel_hostelblock_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hostel_hostelfloor" (
    "id" BIGSERIAL NOT NULL,
    "block_id" BIGINT NOT NULL,
    "floor_number" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "hostel_hostelfloor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hostel_hostelleave" (
    "id" BIGSERIAL NOT NULL,
    "student_id" BIGINT NOT NULL,
    "from_date" TIMESTAMP(3) NOT NULL,
    "to_date" TIMESTAMP(3) NOT NULL,
    "destination" TEXT NOT NULL DEFAULT '',
    "reason" TEXT NOT NULL DEFAULT '',
    "status" TEXT NOT NULL,
    "approved_by_id" BIGINT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "hostel_hostelleave_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hostel_hostelroom" (
    "id" BIGSERIAL NOT NULL,
    "floor_id" BIGINT NOT NULL,
    "room_no" TEXT NOT NULL,
    "occupancy_type" TEXT NOT NULL,
    "capacity" INTEGER NOT NULL,
    "monthly_rent" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "hostel_hostelroom_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hostel_hostelvisitor" (
    "id" BIGSERIAL NOT NULL,
    "student_id" BIGINT NOT NULL,
    "visitor_name" TEXT NOT NULL,
    "relation" TEXT NOT NULL DEFAULT '',
    "phone" TEXT NOT NULL DEFAULT '',
    "id_proof" TEXT NOT NULL DEFAULT '',
    "in_time" TIMESTAMP(3) NOT NULL,
    "out_time" TIMESTAMP(3),
    "status" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "hostel_hostelvisitor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hostel_mess" (
    "id" BIGSERIAL NOT NULL,
    "hostel_id" BIGINT NOT NULL,
    "name" TEXT NOT NULL,
    "monthly_charge" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "contractor" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "hostel_mess_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hostel_messbill" (
    "id" BIGSERIAL NOT NULL,
    "student_id" BIGINT NOT NULL,
    "mess_id" BIGINT NOT NULL,
    "period_start" TIMESTAMP(3) NOT NULL,
    "period_end" TIMESTAMP(3) NOT NULL,
    "amount" DECIMAL(65,30) NOT NULL,
    "paid" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "hostel_messbill_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hostel_messmenu" (
    "id" BIGSERIAL NOT NULL,
    "mess_id" BIGINT NOT NULL,
    "day_of_week" INTEGER NOT NULL,
    "meal_type" TEXT NOT NULL,
    "items" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "hostel_messmenu_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hostel_roomallocation" (
    "id" BIGSERIAL NOT NULL,
    "student_id" BIGINT NOT NULL,
    "room_id" BIGINT NOT NULL,
    "allocated_from" TIMESTAMP(3) NOT NULL,
    "allocated_to" TIMESTAMP(3),
    "status" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "hostel_roomallocation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "leaves_employeeattendance" (
    "id" BIGSERIAL NOT NULL,
    "employee_id" BIGINT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "shift_id" BIGINT,
    "check_in" TIMESTAMP(3),
    "check_out" TIMESTAMP(3),
    "status" TEXT NOT NULL,
    "source" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "leaves_employeeattendance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "leaves_holiday" (
    "id" BIGSERIAL NOT NULL,
    "holiday_list_id" BIGINT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL,
    "is_optional" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "leaves_holiday_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "leaves_holidaylist" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "academic_year_id" BIGINT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "leaves_holidaylist_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "leaves_leaveapplication" (
    "id" BIGSERIAL NOT NULL,
    "employee_id" BIGINT NOT NULL,
    "leave_type_id" BIGINT NOT NULL,
    "from_date" TIMESTAMP(3) NOT NULL,
    "to_date" TIMESTAMP(3) NOT NULL,
    "half_day" BOOLEAN NOT NULL DEFAULT false,
    "reason" TEXT NOT NULL DEFAULT '',
    "status" TEXT NOT NULL,
    "approved_by_id" BIGINT,
    "approved_on" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "leaves_leaveapplication_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "leaves_leavebalance" (
    "id" BIGSERIAL NOT NULL,
    "employee_id" BIGINT NOT NULL,
    "leave_type_id" BIGINT NOT NULL,
    "year" INTEGER NOT NULL,
    "balance" DECIMAL(65,30) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "leaves_leavebalance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "leaves_leavepolicy" (
    "id" BIGSERIAL NOT NULL,
    "leave_type_id" BIGINT NOT NULL,
    "designation_id" BIGINT,
    "employment_type" TEXT NOT NULL DEFAULT '',
    "annual_quota" DECIMAL(65,30) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "leaves_leavepolicy_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "leaves_leavetype" (
    "id" BIGSERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "is_paid" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "leaves_leavetype_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "leaves_shift" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "start_time" TIMESTAMP(3) NOT NULL,
    "end_time" TIMESTAMP(3) NOT NULL,
    "grace_minutes" INTEGER NOT NULL DEFAULT 10,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "leaves_shift_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "library_author" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "bio" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "library_author_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "library_book" (
    "id" BIGSERIAL NOT NULL,
    "isbn" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "subtitle" TEXT NOT NULL DEFAULT '',
    "publisher_id" BIGINT,
    "category_id" BIGINT,
    "edition" TEXT NOT NULL DEFAULT '',
    "year_of_publication" INTEGER,
    "language" TEXT NOT NULL DEFAULT '',
    "cover_image" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "library_book_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "library_bookauthor" (
    "id" BIGSERIAL NOT NULL,
    "book_id" BIGINT NOT NULL,
    "author_id" BIGINT NOT NULL,
    "author_order" INTEGER NOT NULL DEFAULT 1,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "library_bookauthor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "library_bookcategory" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "library_bookcategory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "library_bookcopy" (
    "id" BIGSERIAL NOT NULL,
    "book_id" BIGINT NOT NULL,
    "accession_no" TEXT NOT NULL,
    "barcode" TEXT NOT NULL DEFAULT '',
    "shelf_location" TEXT NOT NULL DEFAULT '',
    "status" TEXT NOT NULL,
    "price" DECIMAL(65,30),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "library_bookcopy_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "library_bookissue" (
    "id" BIGSERIAL NOT NULL,
    "copy_id" BIGINT NOT NULL,
    "member_id" BIGINT NOT NULL,
    "issue_date" TIMESTAMP(3) NOT NULL,
    "due_date" TIMESTAMP(3) NOT NULL,
    "return_date" TIMESTAMP(3),
    "status" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "library_bookissue_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "library_bookreservation" (
    "id" BIGSERIAL NOT NULL,
    "book_id" BIGINT NOT NULL,
    "member_id" BIGINT NOT NULL,
    "reserved_on" TIMESTAMP(3) NOT NULL,
    "fulfilled_on" TIMESTAMP(3),
    "status" TEXT NOT NULL DEFAULT 'pending',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "library_bookreservation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "library_libraryfine" (
    "id" BIGSERIAL NOT NULL,
    "issue_id" BIGINT NOT NULL,
    "amount" DECIMAL(65,30) NOT NULL,
    "reason" TEXT NOT NULL DEFAULT '',
    "paid" BOOLEAN NOT NULL DEFAULT false,
    "paid_on" TIMESTAMP(3),
    "journal_entry_id" BIGINT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "library_libraryfine_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "library_librarymember" (
    "id" BIGSERIAL NOT NULL,
    "user_id" BIGINT NOT NULL,
    "member_type" TEXT NOT NULL,
    "membership_id" TEXT NOT NULL,
    "valid_from" TIMESTAMP(3) NOT NULL,
    "valid_until" TIMESTAMP(3),
    "max_books_allowed" INTEGER NOT NULL DEFAULT 3,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "library_librarymember_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "library_publisher" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "library_publisher_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lms_assignment" (
    "id" BIGSERIAL NOT NULL,
    "offering_id" BIGINT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "max_marks" DECIMAL(65,30) NOT NULL DEFAULT 100,
    "published_at" TIMESTAMP(3),
    "due_at" TIMESTAMP(3) NOT NULL,
    "allow_late_submission" BOOLEAN NOT NULL DEFAULT false,
    "status" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "lms_assignment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lms_assignmentsubmission" (
    "id" BIGSERIAL NOT NULL,
    "assignment_id" BIGINT NOT NULL,
    "student_id" BIGINT NOT NULL,
    "submitted_at" TIMESTAMP(3) NOT NULL,
    "file" TEXT,
    "text_answer" TEXT NOT NULL DEFAULT '',
    "marks" DECIMAL(65,30),
    "feedback" TEXT NOT NULL DEFAULT '',
    "status" TEXT NOT NULL,
    "graded_by_id" BIGINT,
    "graded_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "lms_assignmentsubmission_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lms_coursematerial" (
    "id" BIGSERIAL NOT NULL,
    "offering_id" BIGINT NOT NULL,
    "title" TEXT NOT NULL,
    "material_type" TEXT NOT NULL,
    "file" TEXT,
    "external_url" TEXT NOT NULL DEFAULT '',
    "description" TEXT NOT NULL DEFAULT '',
    "uploaded_by_id" BIGINT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "lms_coursematerial_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lms_question" (
    "id" BIGSERIAL NOT NULL,
    "quiz_id" BIGINT NOT NULL,
    "text" TEXT NOT NULL,
    "question_type" TEXT NOT NULL,
    "marks" DECIMAL(65,30) NOT NULL DEFAULT 1,
    "order" INTEGER NOT NULL DEFAULT 1,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "lms_question_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lms_questionoption" (
    "id" BIGSERIAL NOT NULL,
    "question_id" BIGINT NOT NULL,
    "text" TEXT NOT NULL,
    "is_correct" BOOLEAN NOT NULL DEFAULT false,
    "order" INTEGER NOT NULL DEFAULT 1,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "lms_questionoption_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lms_quiz" (
    "id" BIGSERIAL NOT NULL,
    "offering_id" BIGINT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "duration_minutes" INTEGER NOT NULL DEFAULT 30,
    "max_attempts" INTEGER NOT NULL DEFAULT 1,
    "start_at" TIMESTAMP(3),
    "end_at" TIMESTAMP(3),
    "is_published" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "lms_quiz_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lms_quizanswer" (
    "id" BIGSERIAL NOT NULL,
    "attempt_id" BIGINT NOT NULL,
    "question_id" BIGINT NOT NULL,
    "text_answer" TEXT NOT NULL DEFAULT '',
    "awarded_marks" DECIMAL(65,30),
    "is_correct" BOOLEAN,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "lms_quizanswer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lms_quizattempt" (
    "id" BIGSERIAL NOT NULL,
    "quiz_id" BIGINT NOT NULL,
    "student_id" BIGINT NOT NULL,
    "started_at" TIMESTAMP(3) NOT NULL,
    "submitted_at" TIMESTAMP(3),
    "score" DECIMAL(65,30),
    "attempt_no" INTEGER NOT NULL DEFAULT 1,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "lms_quizattempt_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organization_campus" (
    "id" BIGSERIAL NOT NULL,
    "institute_id" BIGINT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "address_id" BIGINT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "organization_campus_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organization_department" (
    "id" BIGSERIAL NOT NULL,
    "school_id" BIGINT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "hod_id" BIGINT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "organization_department_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organization_institute" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "short_code" TEXT NOT NULL,
    "established_on" TIMESTAMP(3),
    "logo" TEXT,
    "website" TEXT NOT NULL DEFAULT '',
    "email" TEXT NOT NULL DEFAULT '',
    "phone" TEXT NOT NULL DEFAULT '',
    "address_id" BIGINT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "organization_institute_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organization_school" (
    "id" BIGSERIAL NOT NULL,
    "campus_id" BIGINT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "dean_id" BIGINT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "organization_school_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payroll_employeesalaryassignment" (
    "id" BIGSERIAL NOT NULL,
    "employee_id" BIGINT NOT NULL,
    "structure_id" BIGINT NOT NULL,
    "effective_from" TIMESTAMP(3) NOT NULL,
    "effective_to" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "payroll_employeesalaryassignment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payroll_payslip" (
    "id" BIGSERIAL NOT NULL,
    "employee_id" BIGINT NOT NULL,
    "period_start" TIMESTAMP(3) NOT NULL,
    "period_end" TIMESTAMP(3) NOT NULL,
    "gross_earnings" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "total_deductions" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "net_pay" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "status" TEXT NOT NULL,
    "paid_on" TIMESTAMP(3),
    "journal_entry_id" BIGINT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "payroll_payslip_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payroll_payslipline" (
    "id" BIGSERIAL NOT NULL,
    "payslip_id" BIGINT NOT NULL,
    "component_id" BIGINT NOT NULL,
    "amount" DECIMAL(65,30) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "payroll_payslipline_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payroll_salarycomponent" (
    "id" BIGSERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "component_type" TEXT NOT NULL,
    "is_taxable" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "payroll_salarycomponent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payroll_salarystructure" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "effective_from" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "payroll_salarystructure_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payroll_salarystructurecomponent" (
    "id" BIGSERIAL NOT NULL,
    "structure_id" BIGINT NOT NULL,
    "component_id" BIGINT NOT NULL,
    "amount" DECIMAL(65,30),
    "percentage_of_id" BIGINT,
    "percentage" DECIMAL(65,30),
    "formula" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "payroll_salarystructurecomponent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "placements_company" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "website" TEXT NOT NULL DEFAULT '',
    "industry" TEXT NOT NULL DEFAULT '',
    "hq_location" TEXT NOT NULL DEFAULT '',
    "contact_name" TEXT NOT NULL DEFAULT '',
    "contact_email" TEXT NOT NULL DEFAULT '',
    "contact_phone" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "placements_company_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "placements_jobposting" (
    "id" BIGSERIAL NOT NULL,
    "drive_id" BIGINT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "role_type" TEXT NOT NULL,
    "ctc" DECIMAL(65,30),
    "stipend" DECIMAL(65,30),
    "location" TEXT NOT NULL DEFAULT '',
    "min_cgpa" DECIMAL(65,30),
    "apply_by" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "placements_jobposting_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "placements_placementapplication" (
    "id" BIGSERIAL NOT NULL,
    "posting_id" BIGINT NOT NULL,
    "student_id" BIGINT NOT NULL,
    "applied_on" TIMESTAMP(3) NOT NULL,
    "resume" TEXT,
    "status" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "placements_placementapplication_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "placements_placementdrive" (
    "id" BIGSERIAL NOT NULL,
    "company_id" BIGINT NOT NULL,
    "academic_year_id" BIGINT NOT NULL,
    "name" TEXT NOT NULL,
    "start_date" TIMESTAMP(3) NOT NULL,
    "end_date" TIMESTAMP(3),
    "eligibility_criteria" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "placements_placementdrive_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "placements_placementinterviewresult" (
    "id" BIGSERIAL NOT NULL,
    "application_id" BIGINT NOT NULL,
    "round_id" BIGINT NOT NULL,
    "result" TEXT NOT NULL,
    "remarks" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "placements_placementinterviewresult_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "placements_placementinterviewround" (
    "id" BIGSERIAL NOT NULL,
    "posting_id" BIGINT NOT NULL,
    "round_no" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "scheduled_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "placements_placementinterviewround_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "placements_placementoffer" (
    "id" BIGSERIAL NOT NULL,
    "application_id" BIGINT NOT NULL,
    "offered_on" TIMESTAMP(3) NOT NULL,
    "ctc" DECIMAL(65,30) NOT NULL,
    "joining_date" TIMESTAMP(3),
    "offer_letter" TEXT,
    "status" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "placements_placementoffer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "recruitment_jobapplicant" (
    "id" BIGSERIAL NOT NULL,
    "opening_id" BIGINT NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT NOT NULL DEFAULT '',
    "resume" TEXT,
    "years_of_experience" DECIMAL(65,30),
    "current_ctc" DECIMAL(65,30),
    "expected_ctc" DECIMAL(65,30),
    "applied_on" TIMESTAMP(3) NOT NULL,
    "status" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "recruitment_jobapplicant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "recruitment_jobopening" (
    "id" BIGSERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "department_id" BIGINT NOT NULL,
    "designation_id" BIGINT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "vacancies" INTEGER NOT NULL DEFAULT 1,
    "min_experience_years" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "opened_on" TIMESTAMP(3) NOT NULL,
    "closing_on" TIMESTAMP(3),
    "status" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "recruitment_jobopening_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "recruitment_recruitmentinterview" (
    "id" BIGSERIAL NOT NULL,
    "applicant_id" BIGINT NOT NULL,
    "round_no" INTEGER NOT NULL DEFAULT 1,
    "scheduled_at" TIMESTAMP(3) NOT NULL,
    "interviewer_id" BIGINT,
    "feedback" TEXT NOT NULL DEFAULT '',
    "rating" INTEGER,
    "result" TEXT NOT NULL DEFAULT 'pending',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "recruitment_recruitmentinterview_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "recruitment_recruitmentoffer" (
    "id" BIGSERIAL NOT NULL,
    "applicant_id" BIGINT NOT NULL,
    "offered_on" TIMESTAMP(3) NOT NULL,
    "ctc" DECIMAL(65,30) NOT NULL,
    "joining_date" TIMESTAMP(3),
    "offer_letter" TEXT,
    "status" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "recruitment_recruitmentoffer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "student_attendance_attendancesession" (
    "id" BIGSERIAL NOT NULL,
    "offering_id" BIGINT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "start_time" TIMESTAMP(3) NOT NULL,
    "end_time" TIMESTAMP(3) NOT NULL,
    "room_id" BIGINT,
    "taken_by_id" BIGINT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "student_attendance_attendancesession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "student_attendance_studentattendance" (
    "id" BIGSERIAL NOT NULL,
    "session_id" BIGINT NOT NULL,
    "student_id" BIGINT NOT NULL,
    "status" TEXT NOT NULL,
    "remarks" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "student_attendance_studentattendance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "students_application" (
    "id" BIGSERIAL NOT NULL,
    "application_no" TEXT NOT NULL,
    "program_id" BIGINT NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "date_of_birth" TIMESTAMP(3),
    "gender" TEXT NOT NULL DEFAULT '',
    "previous_qualification" TEXT NOT NULL DEFAULT '',
    "previous_percentage" DECIMAL(65,30),
    "entrance_exam" TEXT NOT NULL DEFAULT '',
    "entrance_score" DECIMAL(65,30),
    "status" TEXT NOT NULL,
    "applied_on" TIMESTAMP(3) NOT NULL,
    "decision_on" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "students_application_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "students_guardian" (
    "id" BIGSERIAL NOT NULL,
    "user_id" BIGINT,
    "name" TEXT NOT NULL,
    "relation" TEXT NOT NULL,
    "occupation" TEXT NOT NULL DEFAULT '',
    "annual_income" DECIMAL(65,30),
    "phone" TEXT NOT NULL DEFAULT '',
    "email" TEXT NOT NULL DEFAULT '',
    "address_id" BIGINT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "students_guardian_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "students_student" (
    "id" BIGSERIAL NOT NULL,
    "user_id" BIGINT NOT NULL,
    "enrollment_no" TEXT NOT NULL,
    "roll_no" TEXT NOT NULL,
    "program_id" BIGINT NOT NULL,
    "batch_id" BIGINT NOT NULL,
    "current_term_id" BIGINT,
    "current_section_id" BIGINT,
    "admission_date" TIMESTAMP(3) NOT NULL,
    "admission_type" TEXT NOT NULL,
    "category" TEXT NOT NULL DEFAULT '',
    "religion" TEXT NOT NULL DEFAULT '',
    "nationality" TEXT NOT NULL DEFAULT 'Indian',
    "blood_group" TEXT NOT NULL DEFAULT '',
    "aadhaar_no" TEXT NOT NULL DEFAULT '',
    "pan_no" TEXT NOT NULL DEFAULT '',
    "status" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "students_student_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "students_studentenrollment" (
    "id" BIGSERIAL NOT NULL,
    "student_id" BIGINT NOT NULL,
    "offering_id" BIGINT NOT NULL,
    "enrolled_on" TIMESTAMP(3) NOT NULL,
    "status" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "students_studentenrollment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "students_studentguardian" (
    "id" BIGSERIAL NOT NULL,
    "student_id" BIGINT NOT NULL,
    "guardian_id" BIGINT NOT NULL,
    "is_primary" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "students_studentguardian_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "timetable_room" (
    "id" BIGSERIAL NOT NULL,
    "campus_id" BIGINT NOT NULL,
    "building" TEXT NOT NULL DEFAULT '',
    "floor" INTEGER,
    "room_no" TEXT NOT NULL,
    "room_type" TEXT NOT NULL,
    "capacity" INTEGER NOT NULL DEFAULT 0,
    "has_projector" BOOLEAN NOT NULL DEFAULT false,
    "has_ac" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "timetable_room_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "timetable_timeslot" (
    "id" BIGSERIAL NOT NULL,
    "day_of_week" INTEGER NOT NULL,
    "start_time" TIMESTAMP(3) NOT NULL,
    "end_time" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "timetable_timeslot_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "timetable_timetableentry" (
    "id" BIGSERIAL NOT NULL,
    "section_id" BIGINT NOT NULL,
    "offering_id" BIGINT NOT NULL,
    "time_slot_id" BIGINT NOT NULL,
    "teacher_id" BIGINT NOT NULL,
    "room_id" BIGINT NOT NULL,
    "effective_from" TIMESTAMP(3) NOT NULL,
    "effective_to" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "timetable_timetableentry_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_Course_prerequisites_Course" (
    "A" BIGINT NOT NULL,
    "B" BIGINT NOT NULL,

    CONSTRAINT "_Course_prerequisites_Course_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateTable
CREATE TABLE "_Book_authors_Author" (
    "A" BIGINT NOT NULL,
    "B" BIGINT NOT NULL,

    CONSTRAINT "_Book_authors_Author_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateTable
CREATE TABLE "_QuizAnswer_selected_options_QuestionOption" (
    "A" BIGINT NOT NULL,
    "B" BIGINT NOT NULL,

    CONSTRAINT "_QuizAnswer_selected_options_QuestionOption_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateTable
CREATE TABLE "_JobPosting_eligible_programs_Program" (
    "A" BIGINT NOT NULL,
    "B" BIGINT NOT NULL,

    CONSTRAINT "_JobPosting_eligible_programs_Program_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE UNIQUE INDEX "academic_academicyear_name_key" ON "academic_academicyear"("name");

-- CreateIndex
CREATE UNIQUE INDEX "accounting_accountgroup_code_key" ON "accounting_accountgroup"("code");

-- CreateIndex
CREATE UNIQUE INDEX "accounting_chartofaccount_code_key" ON "accounting_chartofaccount"("code");

-- CreateIndex
CREATE UNIQUE INDEX "accounting_fiscalyear_name_key" ON "accounting_fiscalyear"("name");

-- CreateIndex
CREATE UNIQUE INDEX "accounting_journalentry_entry_no_key" ON "accounting_journalentry"("entry_no");

-- CreateIndex
CREATE UNIQUE INDEX "alumni_alumni_user_id_key" ON "alumni_alumni"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "alumni_alumni_student_id_key" ON "alumni_alumni"("student_id");

-- CreateIndex
CREATE UNIQUE INDEX "assets_asset_asset_tag_key" ON "assets_asset"("asset_tag");

-- CreateIndex
CREATE UNIQUE INDEX "assets_assetcategory_name_key" ON "assets_assetcategory"("name");

-- CreateIndex
CREATE UNIQUE INDEX "assets_purchase_po_no_key" ON "assets_purchase"("po_no");

-- CreateIndex
CREATE UNIQUE INDEX "assets_vendor_name_key" ON "assets_vendor"("name");

-- CreateIndex
CREATE UNIQUE INDEX "audit_setting_key_key" ON "audit_setting"("key");

-- CreateIndex
CREATE UNIQUE INDEX "core_currency_code_key" ON "core_currency"("code");

-- CreateIndex
CREATE UNIQUE INDEX "core_role_code_key" ON "core_role"("code");

-- CreateIndex
CREATE UNIQUE INDEX "core_user_email_key" ON "core_user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "courses_course_code_key" ON "courses_course"("code");

-- CreateIndex
CREATE UNIQUE INDEX "employees_designation_name_key" ON "employees_designation"("name");

-- CreateIndex
CREATE UNIQUE INDEX "employees_employee_user_id_key" ON "employees_employee"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "employees_employee_employee_no_key" ON "employees_employee"("employee_no");

-- CreateIndex
CREATE UNIQUE INDEX "exams_examtype_name_key" ON "exams_examtype"("name");

-- CreateIndex
CREATE UNIQUE INDEX "exams_studentcourseresult_enrollment_id_key" ON "exams_studentcourseresult"("enrollment_id");

-- CreateIndex
CREATE UNIQUE INDEX "exams_studentcumulativeresult_student_id_key" ON "exams_studentcumulativeresult"("student_id");

-- CreateIndex
CREATE UNIQUE INDEX "fees_feecategory_name_key" ON "fees_feecategory"("name");

-- CreateIndex
CREATE UNIQUE INDEX "fees_feehead_code_key" ON "fees_feehead"("code");

-- CreateIndex
CREATE UNIQUE INDEX "fees_feeinvoice_invoice_no_key" ON "fees_feeinvoice"("invoice_no");

-- CreateIndex
CREATE UNIQUE INDEX "fees_payment_payment_no_key" ON "fees_payment"("payment_no");

-- CreateIndex
CREATE UNIQUE INDEX "fees_scholarship_name_key" ON "fees_scholarship"("name");

-- CreateIndex
CREATE UNIQUE INDEX "grading_gradingscheme_name_key" ON "grading_gradingscheme"("name");

-- CreateIndex
CREATE UNIQUE INDEX "hostel_hostel_code_key" ON "hostel_hostel"("code");

-- CreateIndex
CREATE UNIQUE INDEX "hostel_messmenu_day_of_week_meal_type_key" ON "hostel_messmenu"("day_of_week", "meal_type");

-- CreateIndex
CREATE UNIQUE INDEX "leaves_leavetype_code_key" ON "leaves_leavetype"("code");

-- CreateIndex
CREATE UNIQUE INDEX "leaves_shift_name_key" ON "leaves_shift"("name");

-- CreateIndex
CREATE UNIQUE INDEX "library_book_isbn_key" ON "library_book"("isbn");

-- CreateIndex
CREATE UNIQUE INDEX "library_bookcategory_name_key" ON "library_bookcategory"("name");

-- CreateIndex
CREATE UNIQUE INDEX "library_bookcopy_accession_no_key" ON "library_bookcopy"("accession_no");

-- CreateIndex
CREATE UNIQUE INDEX "library_librarymember_user_id_key" ON "library_librarymember"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "library_librarymember_membership_id_key" ON "library_librarymember"("membership_id");

-- CreateIndex
CREATE UNIQUE INDEX "library_publisher_name_key" ON "library_publisher"("name");

-- CreateIndex
CREATE UNIQUE INDEX "organization_institute_short_code_key" ON "organization_institute"("short_code");

-- CreateIndex
CREATE UNIQUE INDEX "payroll_payslip_period_start_period_end_key" ON "payroll_payslip"("period_start", "period_end");

-- CreateIndex
CREATE UNIQUE INDEX "payroll_salarycomponent_code_key" ON "payroll_salarycomponent"("code");

-- CreateIndex
CREATE UNIQUE INDEX "placements_company_name_key" ON "placements_company"("name");

-- CreateIndex
CREATE UNIQUE INDEX "placements_placementoffer_application_id_key" ON "placements_placementoffer"("application_id");

-- CreateIndex
CREATE UNIQUE INDEX "recruitment_recruitmentoffer_applicant_id_key" ON "recruitment_recruitmentoffer"("applicant_id");

-- CreateIndex
CREATE UNIQUE INDEX "student_attendance_attendancesession_date_start_time_key" ON "student_attendance_attendancesession"("date", "start_time");

-- CreateIndex
CREATE UNIQUE INDEX "students_application_application_no_key" ON "students_application"("application_no");

-- CreateIndex
CREATE UNIQUE INDEX "students_guardian_user_id_key" ON "students_guardian"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "students_student_user_id_key" ON "students_student"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "students_student_enrollment_no_key" ON "students_student"("enrollment_no");

-- CreateIndex
CREATE UNIQUE INDEX "timetable_room_building_room_no_key" ON "timetable_room"("building", "room_no");

-- CreateIndex
CREATE UNIQUE INDEX "timetable_timeslot_day_of_week_start_time_end_time_key" ON "timetable_timeslot"("day_of_week", "start_time", "end_time");

-- CreateIndex
CREATE INDEX "_Course_prerequisites_Course_B_index" ON "_Course_prerequisites_Course"("B");

-- CreateIndex
CREATE INDEX "_Book_authors_Author_B_index" ON "_Book_authors_Author"("B");

-- CreateIndex
CREATE INDEX "_QuizAnswer_selected_options_QuestionOption_B_index" ON "_QuizAnswer_selected_options_QuestionOption"("B");

-- CreateIndex
CREATE INDEX "_JobPosting_eligible_programs_Program_B_index" ON "_JobPosting_eligible_programs_Program"("B");

-- AddForeignKey
ALTER TABLE "academic_academicterm" ADD CONSTRAINT "academic_academicterm_academic_year_id_fkey" FOREIGN KEY ("academic_year_id") REFERENCES "academic_academicyear"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "academic_batch" ADD CONSTRAINT "academic_batch_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "academic_program"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "academic_program" ADD CONSTRAINT "academic_program_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "organization_department"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "academic_program" ADD CONSTRAINT "academic_program_grading_scheme_id_fkey" FOREIGN KEY ("grading_scheme_id") REFERENCES "grading_gradingscheme"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "academic_section" ADD CONSTRAINT "academic_section_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "academic_batch"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "academic_section" ADD CONSTRAINT "academic_section_term_id_fkey" FOREIGN KEY ("term_id") REFERENCES "academic_academicterm"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "academic_section" ADD CONSTRAINT "academic_section_class_teacher_id_fkey" FOREIGN KEY ("class_teacher_id") REFERENCES "employees_employee"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "accounting_accountgroup" ADD CONSTRAINT "accounting_accountgroup_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "accounting_accountgroup"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "accounting_chartofaccount" ADD CONSTRAINT "accounting_chartofaccount_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "accounting_accountgroup"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "accounting_chartofaccount" ADD CONSTRAINT "accounting_chartofaccount_currency_id_fkey" FOREIGN KEY ("currency_id") REFERENCES "core_currency"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "accounting_journalentry" ADD CONSTRAINT "accounting_journalentry_fiscal_year_id_fkey" FOREIGN KEY ("fiscal_year_id") REFERENCES "accounting_fiscalyear"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "accounting_journalentry" ADD CONSTRAINT "accounting_journalentry_posted_by_id_fkey" FOREIGN KEY ("posted_by_id") REFERENCES "core_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "accounting_journalline" ADD CONSTRAINT "accounting_journalline_entry_id_fkey" FOREIGN KEY ("entry_id") REFERENCES "accounting_journalentry"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "accounting_journalline" ADD CONSTRAINT "accounting_journalline_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "accounting_chartofaccount"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "alumni_alumni" ADD CONSTRAINT "alumni_alumni_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "core_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "alumni_alumni" ADD CONSTRAINT "alumni_alumni_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students_student"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "alumni_alumni" ADD CONSTRAINT "alumni_alumni_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "academic_program"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "alumni_alumni" ADD CONSTRAINT "alumni_alumni_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "academic_batch"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "alumni_alumnidonation" ADD CONSTRAINT "alumni_alumnidonation_alumni_id_fkey" FOREIGN KEY ("alumni_id") REFERENCES "alumni_alumni"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "alumni_alumnidonation" ADD CONSTRAINT "alumni_alumnidonation_journal_entry_id_fkey" FOREIGN KEY ("journal_entry_id") REFERENCES "accounting_journalentry"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "alumni_alumnieventattendee" ADD CONSTRAINT "alumni_alumnieventattendee_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "alumni_alumnievent"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "alumni_alumnieventattendee" ADD CONSTRAINT "alumni_alumnieventattendee_alumni_id_fkey" FOREIGN KEY ("alumni_id") REFERENCES "alumni_alumni"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assets_asset" ADD CONSTRAINT "assets_asset_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "assets_assetcategory"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assets_asset" ADD CONSTRAINT "assets_asset_vendor_id_fkey" FOREIGN KEY ("vendor_id") REFERENCES "assets_vendor"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assets_assetassignment" ADD CONSTRAINT "assets_assetassignment_asset_id_fkey" FOREIGN KEY ("asset_id") REFERENCES "assets_asset"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assets_purchase" ADD CONSTRAINT "assets_purchase_vendor_id_fkey" FOREIGN KEY ("vendor_id") REFERENCES "assets_vendor"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assets_purchase" ADD CONSTRAINT "assets_purchase_journal_entry_id_fkey" FOREIGN KEY ("journal_entry_id") REFERENCES "accounting_journalentry"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assets_purchaseitem" ADD CONSTRAINT "assets_purchaseitem_purchase_id_fkey" FOREIGN KEY ("purchase_id") REFERENCES "assets_purchase"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assets_purchaseitem" ADD CONSTRAINT "assets_purchaseitem_asset_id_fkey" FOREIGN KEY ("asset_id") REFERENCES "assets_asset"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_auditlog" ADD CONSTRAINT "audit_auditlog_actor_id_fkey" FOREIGN KEY ("actor_id") REFERENCES "core_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "communication_announcement" ADD CONSTRAINT "communication_announcement_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "organization_department"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "communication_announcement" ADD CONSTRAINT "communication_announcement_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "academic_program"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "communication_announcement" ADD CONSTRAINT "communication_announcement_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "academic_batch"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "communication_announcement" ADD CONSTRAINT "communication_announcement_author_id_fkey" FOREIGN KEY ("author_id") REFERENCES "core_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "communication_notification" ADD CONSTRAINT "communication_notification_recipient_id_fkey" FOREIGN KEY ("recipient_id") REFERENCES "core_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core_document" ADD CONSTRAINT "core_document_uploaded_by_id_fkey" FOREIGN KEY ("uploaded_by_id") REFERENCES "core_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core_document" ADD CONSTRAINT "core_document_verified_by_id_fkey" FOREIGN KEY ("verified_by_id") REFERENCES "core_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core_emergencycontact" ADD CONSTRAINT "core_emergencycontact_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "core_address"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core_useraddress" ADD CONSTRAINT "core_useraddress_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "core_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core_useraddress" ADD CONSTRAINT "core_useraddress_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "core_address"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core_userrole" ADD CONSTRAINT "core_userrole_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "core_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core_userrole" ADD CONSTRAINT "core_userrole_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "core_role"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core_userrole" ADD CONSTRAINT "core_userrole_assigned_by_id_fkey" FOREIGN KEY ("assigned_by_id") REFERENCES "core_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "courses_course" ADD CONSTRAINT "courses_course_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "organization_department"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "courses_courseoffering" ADD CONSTRAINT "courses_courseoffering_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "courses_course"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "courses_courseoffering" ADD CONSTRAINT "courses_courseoffering_term_id_fkey" FOREIGN KEY ("term_id") REFERENCES "academic_academicterm"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "courses_courseoffering" ADD CONSTRAINT "courses_courseoffering_section_id_fkey" FOREIGN KEY ("section_id") REFERENCES "academic_section"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "courses_courseoffering" ADD CONSTRAINT "courses_courseoffering_primary_teacher_id_fkey" FOREIGN KEY ("primary_teacher_id") REFERENCES "employees_employee"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "courses_courseoffering" ADD CONSTRAINT "courses_courseoffering_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "timetable_room"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "courses_courseprerequisite" ADD CONSTRAINT "courses_courseprerequisite_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "courses_course"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "courses_courseprerequisite" ADD CONSTRAINT "courses_courseprerequisite_prereq_course_id_fkey" FOREIGN KEY ("prereq_course_id") REFERENCES "courses_course"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "courses_programcourse" ADD CONSTRAINT "courses_programcourse_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "academic_program"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "courses_programcourse" ADD CONSTRAINT "courses_programcourse_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "courses_course"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "courses_syllabustopic" ADD CONSTRAINT "courses_syllabustopic_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "courses_course"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "courses_teachingassignment" ADD CONSTRAINT "courses_teachingassignment_offering_id_fkey" FOREIGN KEY ("offering_id") REFERENCES "courses_courseoffering"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "courses_teachingassignment" ADD CONSTRAINT "courses_teachingassignment_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees_employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employees_employee" ADD CONSTRAINT "employees_employee_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "core_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employees_employee" ADD CONSTRAINT "employees_employee_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "organization_department"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employees_employee" ADD CONSTRAINT "employees_employee_designation_id_fkey" FOREIGN KEY ("designation_id") REFERENCES "employees_designation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employees_employee" ADD CONSTRAINT "employees_employee_reports_to_id_fkey" FOREIGN KEY ("reports_to_id") REFERENCES "employees_employee"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employees_qualification" ADD CONSTRAINT "employees_qualification_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees_employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employees_workexperience" ADD CONSTRAINT "employees_workexperience_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees_employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exams_exam" ADD CONSTRAINT "exams_exam_term_id_fkey" FOREIGN KEY ("term_id") REFERENCES "academic_academicterm"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exams_exam" ADD CONSTRAINT "exams_exam_exam_type_id_fkey" FOREIGN KEY ("exam_type_id") REFERENCES "exams_examtype"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exams_examschedule" ADD CONSTRAINT "exams_examschedule_exam_id_fkey" FOREIGN KEY ("exam_id") REFERENCES "exams_exam"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exams_examschedule" ADD CONSTRAINT "exams_examschedule_offering_id_fkey" FOREIGN KEY ("offering_id") REFERENCES "courses_courseoffering"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exams_examschedule" ADD CONSTRAINT "exams_examschedule_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "timetable_room"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exams_studentcourseresult" ADD CONSTRAINT "exams_studentcourseresult_enrollment_id_fkey" FOREIGN KEY ("enrollment_id") REFERENCES "students_studentenrollment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exams_studentcourseresult" ADD CONSTRAINT "exams_studentcourseresult_grade_band_id_fkey" FOREIGN KEY ("grade_band_id") REFERENCES "grading_gradeband"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exams_studentcumulativeresult" ADD CONSTRAINT "exams_studentcumulativeresult_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students_student"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exams_studentmark" ADD CONSTRAINT "exams_studentmark_schedule_id_fkey" FOREIGN KEY ("schedule_id") REFERENCES "exams_examschedule"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exams_studentmark" ADD CONSTRAINT "exams_studentmark_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students_student"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exams_studenttermresult" ADD CONSTRAINT "exams_studenttermresult_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students_student"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exams_studenttermresult" ADD CONSTRAINT "exams_studenttermresult_term_id_fkey" FOREIGN KEY ("term_id") REFERENCES "academic_academicterm"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fees_feehead" ADD CONSTRAINT "fees_feehead_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "fees_feecategory"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fees_feeinvoice" ADD CONSTRAINT "fees_feeinvoice_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students_student"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fees_feeinvoice" ADD CONSTRAINT "fees_feeinvoice_term_id_fkey" FOREIGN KEY ("term_id") REFERENCES "academic_academicterm"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fees_feeinvoice" ADD CONSTRAINT "fees_feeinvoice_journal_entry_id_fkey" FOREIGN KEY ("journal_entry_id") REFERENCES "accounting_journalentry"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fees_feeinvoiceline" ADD CONSTRAINT "fees_feeinvoiceline_invoice_id_fkey" FOREIGN KEY ("invoice_id") REFERENCES "fees_feeinvoice"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fees_feeinvoiceline" ADD CONSTRAINT "fees_feeinvoiceline_fee_head_id_fkey" FOREIGN KEY ("fee_head_id") REFERENCES "fees_feehead"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fees_feestructure" ADD CONSTRAINT "fees_feestructure_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "academic_program"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fees_feestructure" ADD CONSTRAINT "fees_feestructure_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "academic_batch"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fees_feestructure" ADD CONSTRAINT "fees_feestructure_term_id_fkey" FOREIGN KEY ("term_id") REFERENCES "academic_academicterm"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fees_feestructureitem" ADD CONSTRAINT "fees_feestructureitem_structure_id_fkey" FOREIGN KEY ("structure_id") REFERENCES "fees_feestructure"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fees_feestructureitem" ADD CONSTRAINT "fees_feestructureitem_fee_head_id_fkey" FOREIGN KEY ("fee_head_id") REFERENCES "fees_feehead"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fees_payment" ADD CONSTRAINT "fees_payment_invoice_id_fkey" FOREIGN KEY ("invoice_id") REFERENCES "fees_feeinvoice"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fees_payment" ADD CONSTRAINT "fees_payment_received_by_id_fkey" FOREIGN KEY ("received_by_id") REFERENCES "employees_employee"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fees_payment" ADD CONSTRAINT "fees_payment_journal_entry_id_fkey" FOREIGN KEY ("journal_entry_id") REFERENCES "accounting_journalentry"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fees_refund" ADD CONSTRAINT "fees_refund_payment_id_fkey" FOREIGN KEY ("payment_id") REFERENCES "fees_payment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fees_refund" ADD CONSTRAINT "fees_refund_journal_entry_id_fkey" FOREIGN KEY ("journal_entry_id") REFERENCES "accounting_journalentry"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fees_studentscholarship" ADD CONSTRAINT "fees_studentscholarship_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students_student"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fees_studentscholarship" ADD CONSTRAINT "fees_studentscholarship_scholarship_id_fkey" FOREIGN KEY ("scholarship_id") REFERENCES "fees_scholarship"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fees_studentscholarship" ADD CONSTRAINT "fees_studentscholarship_approved_by_id_fkey" FOREIGN KEY ("approved_by_id") REFERENCES "employees_employee"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "grading_gradeband" ADD CONSTRAINT "grading_gradeband_scheme_id_fkey" FOREIGN KEY ("scheme_id") REFERENCES "grading_gradingscheme"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "grading_gradeconversionrule" ADD CONSTRAINT "grading_gradeconversionrule_from_scheme_id_fkey" FOREIGN KEY ("from_scheme_id") REFERENCES "grading_gradingscheme"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "grading_gradeconversionrule" ADD CONSTRAINT "grading_gradeconversionrule_to_scheme_id_fkey" FOREIGN KEY ("to_scheme_id") REFERENCES "grading_gradingscheme"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_hostel" ADD CONSTRAINT "hostel_hostel_campus_id_fkey" FOREIGN KEY ("campus_id") REFERENCES "organization_campus"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_hostel" ADD CONSTRAINT "hostel_hostel_warden_id_fkey" FOREIGN KEY ("warden_id") REFERENCES "employees_employee"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_hostelapplication" ADD CONSTRAINT "hostel_hostelapplication_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students_student"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_hostelapplication" ADD CONSTRAINT "hostel_hostelapplication_preferred_hostel_id_fkey" FOREIGN KEY ("preferred_hostel_id") REFERENCES "hostel_hostel"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_hostelapplication" ADD CONSTRAINT "hostel_hostelapplication_academic_year_id_fkey" FOREIGN KEY ("academic_year_id") REFERENCES "academic_academicyear"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_hostelblock" ADD CONSTRAINT "hostel_hostelblock_hostel_id_fkey" FOREIGN KEY ("hostel_id") REFERENCES "hostel_hostel"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_hostelfloor" ADD CONSTRAINT "hostel_hostelfloor_block_id_fkey" FOREIGN KEY ("block_id") REFERENCES "hostel_hostelblock"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_hostelleave" ADD CONSTRAINT "hostel_hostelleave_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students_student"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_hostelleave" ADD CONSTRAINT "hostel_hostelleave_approved_by_id_fkey" FOREIGN KEY ("approved_by_id") REFERENCES "employees_employee"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_hostelroom" ADD CONSTRAINT "hostel_hostelroom_floor_id_fkey" FOREIGN KEY ("floor_id") REFERENCES "hostel_hostelfloor"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_hostelvisitor" ADD CONSTRAINT "hostel_hostelvisitor_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students_student"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_mess" ADD CONSTRAINT "hostel_mess_hostel_id_fkey" FOREIGN KEY ("hostel_id") REFERENCES "hostel_hostel"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_messbill" ADD CONSTRAINT "hostel_messbill_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students_student"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_messbill" ADD CONSTRAINT "hostel_messbill_mess_id_fkey" FOREIGN KEY ("mess_id") REFERENCES "hostel_mess"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_messmenu" ADD CONSTRAINT "hostel_messmenu_mess_id_fkey" FOREIGN KEY ("mess_id") REFERENCES "hostel_mess"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_roomallocation" ADD CONSTRAINT "hostel_roomallocation_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students_student"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_roomallocation" ADD CONSTRAINT "hostel_roomallocation_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "hostel_hostelroom"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leaves_employeeattendance" ADD CONSTRAINT "leaves_employeeattendance_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees_employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leaves_employeeattendance" ADD CONSTRAINT "leaves_employeeattendance_shift_id_fkey" FOREIGN KEY ("shift_id") REFERENCES "leaves_shift"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leaves_holiday" ADD CONSTRAINT "leaves_holiday_holiday_list_id_fkey" FOREIGN KEY ("holiday_list_id") REFERENCES "leaves_holidaylist"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leaves_holidaylist" ADD CONSTRAINT "leaves_holidaylist_academic_year_id_fkey" FOREIGN KEY ("academic_year_id") REFERENCES "academic_academicyear"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leaves_leaveapplication" ADD CONSTRAINT "leaves_leaveapplication_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees_employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leaves_leaveapplication" ADD CONSTRAINT "leaves_leaveapplication_leave_type_id_fkey" FOREIGN KEY ("leave_type_id") REFERENCES "leaves_leavetype"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leaves_leaveapplication" ADD CONSTRAINT "leaves_leaveapplication_approved_by_id_fkey" FOREIGN KEY ("approved_by_id") REFERENCES "employees_employee"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leaves_leavebalance" ADD CONSTRAINT "leaves_leavebalance_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees_employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leaves_leavebalance" ADD CONSTRAINT "leaves_leavebalance_leave_type_id_fkey" FOREIGN KEY ("leave_type_id") REFERENCES "leaves_leavetype"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leaves_leavepolicy" ADD CONSTRAINT "leaves_leavepolicy_leave_type_id_fkey" FOREIGN KEY ("leave_type_id") REFERENCES "leaves_leavetype"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leaves_leavepolicy" ADD CONSTRAINT "leaves_leavepolicy_designation_id_fkey" FOREIGN KEY ("designation_id") REFERENCES "employees_designation"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "library_book" ADD CONSTRAINT "library_book_publisher_id_fkey" FOREIGN KEY ("publisher_id") REFERENCES "library_publisher"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "library_book" ADD CONSTRAINT "library_book_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "library_bookcategory"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "library_bookauthor" ADD CONSTRAINT "library_bookauthor_book_id_fkey" FOREIGN KEY ("book_id") REFERENCES "library_book"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "library_bookauthor" ADD CONSTRAINT "library_bookauthor_author_id_fkey" FOREIGN KEY ("author_id") REFERENCES "library_author"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "library_bookcopy" ADD CONSTRAINT "library_bookcopy_book_id_fkey" FOREIGN KEY ("book_id") REFERENCES "library_book"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "library_bookissue" ADD CONSTRAINT "library_bookissue_copy_id_fkey" FOREIGN KEY ("copy_id") REFERENCES "library_bookcopy"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "library_bookissue" ADD CONSTRAINT "library_bookissue_member_id_fkey" FOREIGN KEY ("member_id") REFERENCES "library_librarymember"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "library_bookreservation" ADD CONSTRAINT "library_bookreservation_book_id_fkey" FOREIGN KEY ("book_id") REFERENCES "library_book"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "library_bookreservation" ADD CONSTRAINT "library_bookreservation_member_id_fkey" FOREIGN KEY ("member_id") REFERENCES "library_librarymember"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "library_libraryfine" ADD CONSTRAINT "library_libraryfine_issue_id_fkey" FOREIGN KEY ("issue_id") REFERENCES "library_bookissue"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "library_libraryfine" ADD CONSTRAINT "library_libraryfine_journal_entry_id_fkey" FOREIGN KEY ("journal_entry_id") REFERENCES "accounting_journalentry"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "library_librarymember" ADD CONSTRAINT "library_librarymember_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "core_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lms_assignment" ADD CONSTRAINT "lms_assignment_offering_id_fkey" FOREIGN KEY ("offering_id") REFERENCES "courses_courseoffering"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lms_assignmentsubmission" ADD CONSTRAINT "lms_assignmentsubmission_assignment_id_fkey" FOREIGN KEY ("assignment_id") REFERENCES "lms_assignment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lms_assignmentsubmission" ADD CONSTRAINT "lms_assignmentsubmission_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students_student"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lms_assignmentsubmission" ADD CONSTRAINT "lms_assignmentsubmission_graded_by_id_fkey" FOREIGN KEY ("graded_by_id") REFERENCES "employees_employee"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lms_coursematerial" ADD CONSTRAINT "lms_coursematerial_offering_id_fkey" FOREIGN KEY ("offering_id") REFERENCES "courses_courseoffering"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lms_coursematerial" ADD CONSTRAINT "lms_coursematerial_uploaded_by_id_fkey" FOREIGN KEY ("uploaded_by_id") REFERENCES "employees_employee"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lms_question" ADD CONSTRAINT "lms_question_quiz_id_fkey" FOREIGN KEY ("quiz_id") REFERENCES "lms_quiz"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lms_questionoption" ADD CONSTRAINT "lms_questionoption_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "lms_question"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lms_quiz" ADD CONSTRAINT "lms_quiz_offering_id_fkey" FOREIGN KEY ("offering_id") REFERENCES "courses_courseoffering"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lms_quizanswer" ADD CONSTRAINT "lms_quizanswer_attempt_id_fkey" FOREIGN KEY ("attempt_id") REFERENCES "lms_quizattempt"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lms_quizanswer" ADD CONSTRAINT "lms_quizanswer_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "lms_question"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lms_quizattempt" ADD CONSTRAINT "lms_quizattempt_quiz_id_fkey" FOREIGN KEY ("quiz_id") REFERENCES "lms_quiz"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lms_quizattempt" ADD CONSTRAINT "lms_quizattempt_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students_student"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_campus" ADD CONSTRAINT "organization_campus_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "organization_institute"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_campus" ADD CONSTRAINT "organization_campus_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "core_address"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_department" ADD CONSTRAINT "organization_department_school_id_fkey" FOREIGN KEY ("school_id") REFERENCES "organization_school"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_department" ADD CONSTRAINT "organization_department_hod_id_fkey" FOREIGN KEY ("hod_id") REFERENCES "employees_employee"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_institute" ADD CONSTRAINT "organization_institute_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "core_address"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_school" ADD CONSTRAINT "organization_school_campus_id_fkey" FOREIGN KEY ("campus_id") REFERENCES "organization_campus"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_school" ADD CONSTRAINT "organization_school_dean_id_fkey" FOREIGN KEY ("dean_id") REFERENCES "employees_employee"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payroll_employeesalaryassignment" ADD CONSTRAINT "payroll_employeesalaryassignment_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees_employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payroll_employeesalaryassignment" ADD CONSTRAINT "payroll_employeesalaryassignment_structure_id_fkey" FOREIGN KEY ("structure_id") REFERENCES "payroll_salarystructure"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payroll_payslip" ADD CONSTRAINT "payroll_payslip_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees_employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payroll_payslip" ADD CONSTRAINT "payroll_payslip_journal_entry_id_fkey" FOREIGN KEY ("journal_entry_id") REFERENCES "accounting_journalentry"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payroll_payslipline" ADD CONSTRAINT "payroll_payslipline_payslip_id_fkey" FOREIGN KEY ("payslip_id") REFERENCES "payroll_payslip"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payroll_payslipline" ADD CONSTRAINT "payroll_payslipline_component_id_fkey" FOREIGN KEY ("component_id") REFERENCES "payroll_salarycomponent"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payroll_salarystructurecomponent" ADD CONSTRAINT "payroll_salarystructurecomponent_structure_id_fkey" FOREIGN KEY ("structure_id") REFERENCES "payroll_salarystructure"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payroll_salarystructurecomponent" ADD CONSTRAINT "payroll_salarystructurecomponent_component_id_fkey" FOREIGN KEY ("component_id") REFERENCES "payroll_salarycomponent"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payroll_salarystructurecomponent" ADD CONSTRAINT "payroll_salarystructurecomponent_percentage_of_id_fkey" FOREIGN KEY ("percentage_of_id") REFERENCES "payroll_salarycomponent"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placements_jobposting" ADD CONSTRAINT "placements_jobposting_drive_id_fkey" FOREIGN KEY ("drive_id") REFERENCES "placements_placementdrive"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placements_placementapplication" ADD CONSTRAINT "placements_placementapplication_posting_id_fkey" FOREIGN KEY ("posting_id") REFERENCES "placements_jobposting"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placements_placementapplication" ADD CONSTRAINT "placements_placementapplication_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students_student"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placements_placementdrive" ADD CONSTRAINT "placements_placementdrive_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "placements_company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placements_placementdrive" ADD CONSTRAINT "placements_placementdrive_academic_year_id_fkey" FOREIGN KEY ("academic_year_id") REFERENCES "academic_academicyear"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placements_placementinterviewresult" ADD CONSTRAINT "placements_placementinterviewresult_application_id_fkey" FOREIGN KEY ("application_id") REFERENCES "placements_placementapplication"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placements_placementinterviewresult" ADD CONSTRAINT "placements_placementinterviewresult_round_id_fkey" FOREIGN KEY ("round_id") REFERENCES "placements_placementinterviewround"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placements_placementinterviewround" ADD CONSTRAINT "placements_placementinterviewround_posting_id_fkey" FOREIGN KEY ("posting_id") REFERENCES "placements_jobposting"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placements_placementoffer" ADD CONSTRAINT "placements_placementoffer_application_id_fkey" FOREIGN KEY ("application_id") REFERENCES "placements_placementapplication"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recruitment_jobapplicant" ADD CONSTRAINT "recruitment_jobapplicant_opening_id_fkey" FOREIGN KEY ("opening_id") REFERENCES "recruitment_jobopening"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recruitment_jobopening" ADD CONSTRAINT "recruitment_jobopening_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "organization_department"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recruitment_jobopening" ADD CONSTRAINT "recruitment_jobopening_designation_id_fkey" FOREIGN KEY ("designation_id") REFERENCES "employees_designation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recruitment_recruitmentinterview" ADD CONSTRAINT "recruitment_recruitmentinterview_applicant_id_fkey" FOREIGN KEY ("applicant_id") REFERENCES "recruitment_jobapplicant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recruitment_recruitmentinterview" ADD CONSTRAINT "recruitment_recruitmentinterview_interviewer_id_fkey" FOREIGN KEY ("interviewer_id") REFERENCES "employees_employee"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recruitment_recruitmentoffer" ADD CONSTRAINT "recruitment_recruitmentoffer_applicant_id_fkey" FOREIGN KEY ("applicant_id") REFERENCES "recruitment_jobapplicant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_attendance_attendancesession" ADD CONSTRAINT "student_attendance_attendancesession_offering_id_fkey" FOREIGN KEY ("offering_id") REFERENCES "courses_courseoffering"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_attendance_attendancesession" ADD CONSTRAINT "student_attendance_attendancesession_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "timetable_room"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_attendance_attendancesession" ADD CONSTRAINT "student_attendance_attendancesession_taken_by_id_fkey" FOREIGN KEY ("taken_by_id") REFERENCES "employees_employee"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_attendance_studentattendance" ADD CONSTRAINT "student_attendance_studentattendance_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "student_attendance_attendancesession"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_attendance_studentattendance" ADD CONSTRAINT "student_attendance_studentattendance_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students_student"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "students_application" ADD CONSTRAINT "students_application_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "academic_program"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "students_guardian" ADD CONSTRAINT "students_guardian_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "core_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "students_guardian" ADD CONSTRAINT "students_guardian_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "core_address"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "students_student" ADD CONSTRAINT "students_student_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "core_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "students_student" ADD CONSTRAINT "students_student_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "academic_program"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "students_student" ADD CONSTRAINT "students_student_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "academic_batch"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "students_student" ADD CONSTRAINT "students_student_current_term_id_fkey" FOREIGN KEY ("current_term_id") REFERENCES "academic_academicterm"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "students_student" ADD CONSTRAINT "students_student_current_section_id_fkey" FOREIGN KEY ("current_section_id") REFERENCES "academic_section"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "students_studentenrollment" ADD CONSTRAINT "students_studentenrollment_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students_student"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "students_studentenrollment" ADD CONSTRAINT "students_studentenrollment_offering_id_fkey" FOREIGN KEY ("offering_id") REFERENCES "courses_courseoffering"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "students_studentguardian" ADD CONSTRAINT "students_studentguardian_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students_student"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "students_studentguardian" ADD CONSTRAINT "students_studentguardian_guardian_id_fkey" FOREIGN KEY ("guardian_id") REFERENCES "students_guardian"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "timetable_room" ADD CONSTRAINT "timetable_room_campus_id_fkey" FOREIGN KEY ("campus_id") REFERENCES "organization_campus"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "timetable_timetableentry" ADD CONSTRAINT "timetable_timetableentry_section_id_fkey" FOREIGN KEY ("section_id") REFERENCES "academic_section"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "timetable_timetableentry" ADD CONSTRAINT "timetable_timetableentry_offering_id_fkey" FOREIGN KEY ("offering_id") REFERENCES "courses_courseoffering"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "timetable_timetableentry" ADD CONSTRAINT "timetable_timetableentry_time_slot_id_fkey" FOREIGN KEY ("time_slot_id") REFERENCES "timetable_timeslot"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "timetable_timetableentry" ADD CONSTRAINT "timetable_timetableentry_teacher_id_fkey" FOREIGN KEY ("teacher_id") REFERENCES "employees_employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "timetable_timetableentry" ADD CONSTRAINT "timetable_timetableentry_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "timetable_room"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_Course_prerequisites_Course" ADD CONSTRAINT "_Course_prerequisites_Course_A_fkey" FOREIGN KEY ("A") REFERENCES "courses_course"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_Course_prerequisites_Course" ADD CONSTRAINT "_Course_prerequisites_Course_B_fkey" FOREIGN KEY ("B") REFERENCES "courses_course"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_Book_authors_Author" ADD CONSTRAINT "_Book_authors_Author_A_fkey" FOREIGN KEY ("A") REFERENCES "library_author"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_Book_authors_Author" ADD CONSTRAINT "_Book_authors_Author_B_fkey" FOREIGN KEY ("B") REFERENCES "library_book"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_QuizAnswer_selected_options_QuestionOption" ADD CONSTRAINT "_QuizAnswer_selected_options_QuestionOption_A_fkey" FOREIGN KEY ("A") REFERENCES "lms_questionoption"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_QuizAnswer_selected_options_QuestionOption" ADD CONSTRAINT "_QuizAnswer_selected_options_QuestionOption_B_fkey" FOREIGN KEY ("B") REFERENCES "lms_quizanswer"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_JobPosting_eligible_programs_Program" ADD CONSTRAINT "_JobPosting_eligible_programs_Program_A_fkey" FOREIGN KEY ("A") REFERENCES "placements_jobposting"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_JobPosting_eligible_programs_Program" ADD CONSTRAINT "_JobPosting_eligible_programs_Program_B_fkey" FOREIGN KEY ("B") REFERENCES "academic_program"("id") ON DELETE CASCADE ON UPDATE CASCADE;
