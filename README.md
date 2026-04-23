# University Management System (UMS) — Backend

Django 5 + PostgreSQL 14 + DRF backend scaffold for a university management system covering
**academics, students, employees, hostel, library, fees, double-entry accounting, LMS,
placements, recruitment, alumni, and more** — 24 modules total.

This milestone is the **data model + Django admin**. REST APIs come next.

---

## Modules / apps

| #   | App                  | What it holds                                                                                                  |
| --- | -------------------- | -------------------------------------------------------------------------------------------------------------- |
| 1   | `core`               | Custom `User`, `Role`, `Address`, `Currency`, `Document` (polymorphic), `EmergencyContact`                     |
| 2   | `organization`       | Institute → Campus → School → Department (multi-campus-safe)                                                   |
| 3   | `academic`           | AcademicYear, AcademicTerm, Program, Batch, Section                                                            |
| 4   | `courses`            | Course catalogue, `CourseOffering` (per-term instance), `ProgramCourse`, `SyllabusTopic`, `TeachingAssignment` |
| 5   | `students`           | Applications, `Student` profile, Guardians, `StudentEnrollment`                                                |
| 6   | `employees`          | `Employee`, `Designation`, `Qualification`, `WorkExperience`                                                   |
| 7   | `payroll`            | `SalaryComponent`, `SalaryStructure`, `Payslip` (with journal posting)                                         |
| 8   | `leaves`             | LeaveType/Policy/Balance/Application, Holiday, Shift, staff attendance                                         |
| 9   | `student_attendance` | Per-lecture `AttendanceSession` + `StudentAttendance`                                                          |
| 10  | `timetable`          | `Room`, `TimeSlot`, `TimetableEntry` (DB-level clash prevention)                                               |
| 11  | `grading`            | Configurable `GradingScheme` + `GradeBand` + optional `GradeConversionRule`                                    |
| 12  | `exams`              | Exam, ExamSchedule, StudentMark, snapshotted results                                                           |
| 13  | `fees`               | Categories, Heads, Structure, Invoice, Payment, Scholarship, Refund                                            |
| 14  | `accounting`         | Full double-entry ledger: FiscalYear, AccountGroup, ChartOfAccount, JournalEntry, JournalLine                  |
| 15  | `hostel`             | Hostels, Blocks, Floors, Rooms, Allocation (room-level), Mess, Visitors, Leaves                                |
| 16  | `library`            | Books, Authors, Publishers, BookCopy, LibraryMember, BookIssue, LibraryFine                                    |
| 17  | `lms`                | CourseMaterial, Assignment, Submission, Quiz, Question, Option, Attempt, Answer                                |
| 18  | `alumni`             | Alumni profile, AlumniEvent, AlumniDonation                                                                    |
| 19  | `placements`         | Company, PlacementDrive, JobPosting, Application, InterviewRound, Offer                                        |
| 20  | `recruitment`        | JobOpening, JobApplicant, Interview, Offer                                                                     |
| 21  | `assets`             | Vendor, AssetCategory, Asset, AssetAssignment (polymorphic), Purchase                                          |
| 22  | `communication`      | Announcement, Notification, Event                                                                              |
| 23  | `audit`              | `AuditLog` (polymorphic), `Setting`                                                                            |

Full entity-level schema doc: [`docs/SCHEMA.md`](docs/SCHEMA.md).

---

## Quick start

```bash
# 1) Python env
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# 2) Postgres (Ubuntu/Debian)
sudo apt-get install -y postgresql postgresql-contrib libpq-dev
sudo -u postgres psql -c "CREATE USER ums WITH PASSWORD 'ums_dev';"
sudo -u postgres psql -c "CREATE DATABASE ums OWNER ums;"

# 3) Environment
cp .env.example .env
# edit .env if you want different DB credentials / secret key

# 4) Migrate + seed
python manage.py migrate
python manage.py seed_initial

# 5) Create a Django admin user and run the server
python manage.py createsuperuser
python manage.py runserver
```

Then open:

- **Admin UI:** http://localhost:8000/admin/
- **OpenAPI JSON:** http://localhost:8000/api/schema/
- **Swagger UI:** http://localhost:8000/api/docs/
- **ReDoc:** http://localhost:8000/api/redoc/

(API endpoints themselves are the next milestone — only the schema and admin are implemented now.)

---

## What `seed_initial` populates

- **Roles:** admin, student, faculty, hr, accountant, librarian, warden, placement_officer, guardian, alumni, receptionist
- **Default currency:** INR (₹)
- **Designations:** Professor, Associate Professor, Assistant Professor, Lecturer, Lab Assistant, HR Manager, HR Executive, Accountant, Librarian, Warden, Placement Officer, Security, Housekeeping
- **Fee categories:** Tuition, Hostel, Mess, Library, Examination, Transport, Miscellaneous
- **Leave types:** CL, SL, EL, LOP, ML, PL
- **Default grading scheme** (Indian-style): `O, A+, A, B+, B, C, P, F` with 10-point grade-point mapping and 40% pass threshold
- **Chart of accounts:** a standard 5-root-type structure (Assets / Liabilities / Equity / Income / Expense) with 20 accounts ready for fees, payroll, donations, fines, scholarships, etc.

The command is idempotent — safe to re-run.

---

## Project layout

```
ums-backend/
├── config/                 # Django project settings / URLs
├── apps/                   # 23 local apps (see table above)
├── docs/SCHEMA.md          # Full data-model doc with ER diagrams
├── manage.py
├── requirements.txt
├── .env.example
└── README.md
```

---

## Design notes

- **Single-campus-ready, multi-campus-safe.** Institute → Campus → School hierarchy is already
  in place. Running a second campus later is a row insert, not a schema change.
- **Configurable grading.** `GradingScheme` can be percentage / letter / GPA. Programs pick a
  scheme. Bands are DB rows, not hard-coded. Final results are **snapshotted** at
  finalize-time so later band edits don't silently change historic records.
- **Double-entry accounting.** Every financial event (invoice, payment, refund, payslip,
  donation, fine, purchase) carries a `journal_entry` FK. Ledger integrity is enforced with a
  `CHECK` constraint on `JournalLine` requiring exactly one of debit/credit to be non-zero.
- **Template vs instance.** `Course` vs `CourseOffering`, `FeeStructure` vs `FeeInvoice`,
  `Exam` vs `ExamSchedule`, `SalaryStructure` vs `Payslip` — the same pattern applied
  consistently.
- **Polymorphic attachments.** `Document`, `EmergencyContact`, `AssetAssignment`, and
  `JournalLine.party` all use Django's `GenericForeignKey`, so e.g. a Document can be
  attached to any model without new join tables.
- **Hostel.** Room-level allocation (not bed-level) with a partial unique index that prevents
  a student from having more than one active allocation at a time.
- **Timetable.** DB-level unique constraints prevent double-booking a teacher, room, or
  section in the same `TimeSlot`.
- **Audit & soft delete.** Every model carries `created_at`, `updated_at`, `is_active`.
  `AuditLog` can reference any model polymorphically.

---

## Next milestone

1. REST API endpoints (DRF ViewSets) for each module
2. Authentication (JWT) + role-based permissions
3. Business rules (auto-posting journal entries, result finalization, invoice state
   transitions, auto-creating Alumni on graduation, auto-creating Employee on "joined")
4. Seed data for programs / batches / courses (currently only reference data is seeded)
5. Tests
