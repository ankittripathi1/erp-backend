# Used AI for

- claude how to seed a user in the db using drizzle orm.

## auth.routes.ts

- [X] POST /auth/register - Register new user.
- [X] POST /auth/login - User login
- [X] POST /auth/logout - User logout
- [X] GET /auth/me - Get current user profile
- [ ] PUT /auth/change-password - Update password
- [ ] POST /auth/forgot-password - Request password reset
- [ ] POST /auth/reset-password - Reset password with token
- [ ] GET /auth/verify-token - Verify auth token validity

## user.routes.ts

- [X] GET /users - List all users (with pagination and filters)
- [X] GET /users/:id - Get user details
<!-- - [ ] POST /users - Create new user not crating this instead creating a wrapper api for better ues -->
- [X] PUT /users/:id - Update user information
- [X] DELETE /users/:id - Delete/deactivate user(soft delete)
- [X] PUT /users/:id/role - Update user role
- [X] GET /users/:id/permissions - Get user permissions
- [X] PUT /users/:id/permissions - Update user permissions

# Student Management
## student.routes.ts

- [ ] GET /students - List all students (with pagination and filters)
- [ ] GET /students/:id - Get student details with related information
- [ ] POST /students - Create new student
- [ ] PUT /students/:id - Update student information
- [ ] DELETE /students/:id - Delete student record
- [ ] GET /students/batch/:batchId - Get students by batch
- [ ] GET /students/search - Search students by criteria
- [ ] GET /students/:id/academic-history - Get student academic history
- [ ] GET /students/:id/attendance - Get student attendance record
- [ ] GET /students/:id/exam-scores - Get student exam scores
- [ ] GET /students/:id/fees - Get student fees information

Academic Management
academic.routes.ts

GET /academic-years - List all academic years
GET /academic-years/:id - Get academic year details
POST /academic-years - Create academic year
PUT /academic-years/:id - Update academic year
DELETE /academic-years/:id - Delete academic year
PUT /academic-years/:id/activate - Activate/deactivate academic year

course.routes.ts

GET /courses - List all courses
GET /courses/:id - Get course details
POST /courses - Create new course
PUT /courses/:id - Update course
DELETE /courses/:id - Delete course
GET /courses/:id/batches - Get batches for a course

batch.routes.ts

GET /batches - List all batches
GET /batches/:id - Get batch details
POST /batches - Create new batch
PUT /batches/:id - Update batch
DELETE /batches/:id - Delete batch
GET /batches/:id/students - Get students in a batch
GET /batches/:id/subjects - Get subjects for a batch
PUT /batches/:id/activate - Activate/deactivate batch

subject.routes.ts

GET /subjects - List all subjects
GET /subjects/:id - Get subject details
POST /subjects - Create new subject
PUT /subjects/:id - Update subject
DELETE /subjects/:id - Delete subject
GET /subjects/:id/exams - Get exams for a subject
GET /subjects/batch/:batchId - Get subjects by batch

elective-group.routes.ts

GET /elective-groups - List all elective groups
GET /elective-groups/:id - Get elective group details
POST /elective-groups - Create new elective group
PUT /elective-groups/:id - Update elective group
DELETE /elective-groups/:id - Delete elective group
GET /elective-groups/:id/subjects - Get subjects in an elective group

Attendance Management
attendance.routes.ts

GET /attendance/students - List student attendance records
GET /attendance/students/:studentId - Get attendance for specific student
POST /attendance/batch/:batchId - Mark attendance for a batch
PUT /attendance/:id - Update attendance record
GET /attendance/batch/:batchId/date/:date - Get attendance for batch on date
GET /attendance/reports - Get attendance reports
POST /attendance/reports - Generate attendance report
GET /attendance/reports/:id - Get specific attendance report

Examination & Grading
exam.routes.ts

GET /exam-groups - List all exam groups
GET /exam-groups/:id - Get exam group details
POST /exam-groups - Create new exam group
PUT /exam-groups/:id - Update exam group
DELETE /exam-groups/:id - Delete exam group
GET /exam-groups/:id/exams - Get exams in an exam group
PUT /exam-groups/:id/publish - Publish/unpublish exam group
PUT /exam-groups/:id/publish-results - Publish/unpublish exam results

exams.routes.ts

GET /exams - List all exams
GET /exams/:id - Get exam details
POST /exams - Create new exam
PUT /exams/:id - Update exam
DELETE /exams/:id - Delete exam
GET /exams/:id/scores - Get scores for an exam
POST /exams/:id/scores - Add scores for an exam
PUT /exams/:id/scores/:scoreId - Update exam score

grading.routes.ts

GET /grading-levels - List all grading levels
GET /grading-levels/:id - Get grading level details
POST /grading-levels - Create new grading level
PUT /grading-levels/:id - Update grading level
DELETE /grading-levels/:id - Delete grading level
GET /grading-levels/batch/:batchId - Get grading levels for a batch

Timetable Management
timetable.routes.ts

GET /timetables - List all timetables
GET /timetables/:id - Get timetable details
POST /timetables - Create new timetable
PUT /timetables/:id - Update timetable
DELETE /timetables/:id - Delete timetable
GET /timetables/batch/:batchId - Get timetables for a batch
PUT /timetables/:id/activate - Activate/deactivate timetable

timetable-entries.routes.ts

GET /timetable-entries - List timetable entries
GET /timetable-entries/:id - Get timetable entry details
POST /timetable-entries - Create timetable entry
PUT /timetable-entries/:id - Update timetable entry
DELETE /timetable-entries/:id - Delete timetable entry
GET /timetable-entries/timetable/:timetableId/day/:weekday - Get entries by day

class-timing.routes.ts

GET /class-timings - List all class timings
GET /class-timings/:id - Get class timing details
POST /class-timings - Create new class timing
PUT /class-timings/:id - Update class timing
DELETE /class-timings/:id - Delete class timing
GET /class-timings/batch/:batchId - Get class timings for a batch

room.routes.ts

GET /rooms - List all rooms
GET /rooms/:id - Get room details
POST /rooms - Create new room
PUT /rooms/:id - Update room
DELETE /rooms/:id - Delete room
GET /rooms/available - Get available rooms based on time criteria

Financial Management
finance-categories.routes.ts

GET /finance-categories - List all fee categories
GET /finance-categories/:id - Get fee category details
POST /finance-categories - Create new fee category
PUT /finance-categories/:id - Update fee category
DELETE /finance-categories/:id - Delete fee category
GET /finance-categories/batch/:batchId - Get fee categories for a batch

fee-collection.routes.ts

GET /fee-collections - List all fee collections
GET /fee-collections/:id - Get fee collection details
POST /fee-collections - Create new fee collection
PUT /fee-collections/:id - Update fee collection
DELETE /fee-collections/:id - Delete fee collection
GET /fee-collections/batch/:batchId - Get fee collections for a batch

finance-fees.routes.ts

GET /finance-fees - List all student fees
GET /finance-fees/:id - Get student fee details
POST /finance-fees - Create student fee
PUT /finance-fees/:id - Update student fee status
GET /finance-fees/student/:studentId - Get fees for a student
PUT /finance-fees/:id/pay - Mark fee as paid
GET /finance-fees/pending - Get list of pending fees

transaction.routes.ts

GET /transactions - List all transactions
GET /transactions/:id - Get transaction details
POST /transactions - Create new transaction
PUT /transactions/:id - Update transaction
GET /transactions/income - Get income transactions
GET /transactions/expense - Get expense transactions
GET /transactions/reports - Get financial reports

HR Management
employee.routes.ts

GET /employees - List all employees
GET /employees/:id - Get employee details
POST /employees - Create new employee
PUT /employees/:id - Update employee
DELETE /employees/:id - Delete/deactivate employee
GET /employees/search - Search employees by criteria
GET /employees/:id/attendance - Get employee attendance
GET /employees/:id/payslips - Get employee payslips
GET /employees/:id/bank-details - Get employee bank details

employee-category.routes.ts

GET /employee-categories - List all employee categories
GET /employee-categories/:id - Get category details
POST /employee-categories - Create new category
PUT /employee-categories/:id - Update category
DELETE /employee-categories/:id - Delete category

employee-department.routes.ts

GET /employee-departments - List all departments
GET /employee-departments/:id - Get department details
POST /employee-departments - Create new department
PUT /employee-departments/:id - Update department
DELETE /employee-departments/:id - Delete department
GET /employee-departments/:id/employees - Get employees in department

employee-position.routes.ts

GET /employee-positions - List all positions
GET /employee-positions/:id - Get position details
POST /employee-positions - Create new position
PUT /employee-positions/:id - Update position
DELETE /employee-positions/:id - Delete position
GET /employee-positions/category/:categoryId - Get positions by category

employee-attendance.routes.ts

GET /employee-attendance - List attendance records
GET /employee-attendance/:id - Get attendance record details
POST /employee-attendance - Create attendance record
PUT /employee-attendance/:id - Update attendance record
GET /employee-attendance/employee/:employeeId - Get attendance for an employee
GET /employee-attendance/date/:date - Get attendance by date
GET /employee-attendance/reports - Get attendance reports

payslip.routes.ts

GET /payslips - List all payslips
GET /payslips/:id - Get payslip details
POST /payslips - Create new payslip
PUT /payslips/:id - Update payslip
GET /payslips/employee/:employeeId - Get payslips for an employee
PUT /payslips/:id/approve - Approve payslip
PUT /payslips/:id/reject - Reject payslip
GET /payslips/pending - Get pending payslips

Communication Management
notice.routes.ts

GET /notices - List all notices
GET /notices/:id - Get notice details
POST /notices - Create new notice
PUT /notices/:id - Update notice
DELETE /notices/:id - Delete notice
GET /notices/active - Get active notices
GET /notices/batch/:batchId - Get notices for a batch
GET /notices/department/:departmentId - Get notices for a department

message.routes.ts

GET /messages - List user messages
GET /messages/:id - Get message details
POST /messages - Send new message
DELETE /messages/:id - Delete message
GET /messages/inbox - Get received messages
GET /messages/sent - Get sent messages
PUT /messages/:id/read - Mark message as read
GET /messages/unread - Get unread messages

event.routes.ts

GET /events - List all events
GET /events/:id - Get event details
POST /events - Create new event
PUT /events/:id - Update event
DELETE /events/:id - Delete event
GET /events/upcoming - Get upcoming events
GET /events/calendar - Get calendar events
POST /events/:id/students - Add students to event
DELETE /events/:id/students/:studentId - Remove student from event
GET /events/student/:studentId - Get events for a student

Library Management
book.routes.ts

GET /books - List all books
GET /books/:id - Get book details
POST /books - Add new book
PUT /books/:id - Update book
DELETE /books/:id - Delete book
GET /books/search - Search books by criteria
GET /books/available - Get available books
GET /books/category/:categoryId - Get books by category

book-category.routes.ts

GET /book-categories - List all book categories
GET /book-categories/:id - Get category details
POST /book-categories - Create new category
PUT /book-categories/:id - Update category
DELETE /book-categories/:id - Delete category

book-location.routes.ts

GET /book-locations - List all book locations
GET /book-locations/:id - Get location details
POST /book-locations - Create new location
PUT /book-locations/:id - Update location
DELETE /book-locations/:id - Delete location

book-movement.routes.ts

GET /book-movements - List all book movements
GET /book-movements/:id - Get movement details
POST /book-movements - Issue book
PUT /book-movements/:id/return - Return book
GET /book-movements/overdue - Get overdue books
GET /book-movements/user/:userId - Get movements for a user
GET /book-movements/book/:bookId - Get movements for a book
PUT /book-movements/:id/fine - Update fine amount

Inventory Management
inventory-category.routes.ts

GET /inventory-categories - List all categories
GET /inventory-categories/:id - Get category details
POST /inventory-categories - Create new category
PUT /inventory-categories/:id - Update category
DELETE /inventory-categories/:id - Delete category

inventory-item.routes.ts

GET /inventory-items - List all items
GET /inventory-items/:id - Get item details
POST /inventory-items - Create new item
PUT /inventory-items/:id - Update item
DELETE /inventory-items/:id - Delete item
GET /inventory-items/low-stock - Get low stock items

inventory-purchase.routes.ts

GET /inventory-purchases - List all purchases
GET /inventory-purchases/:id - Get purchase details
POST /inventory-purchases - Record new purchase
PUT /inventory-purchases/:id - Update purchase
DELETE /inventory-purchases/:id - Delete purchase
GET /inventory-purchases/item/:itemId - Get purchases for an item

inventory-store.routes.ts

GET /inventory-stores - List all stores
GET /inventory-stores/:id - Get store details
POST /inventory-stores - Create new store
PUT /inventory-stores/:id - Update store
DELETE /inventory-stores/:id - Delete store
GET /inventory-stores/:id/items - Get items in a store

Transport Management
transport-route.routes.ts

GET /transport-routes - List all routes
GET /transport-routes/:id - Get route details
POST /transport-routes - Create new route
PUT /transport-routes/:id - Update route
DELETE /transport-routes/:id - Delete route
GET /transport-routes/:id/vehicles - Get vehicles on a route

transport-vehicle.routes.ts

GET /transport-vehicles - List all vehicles
GET /transport-vehicles/:id - Get vehicle details
POST /transport-vehicles - Register new vehicle
PUT /transport-vehicles/:id - Update vehicle
DELETE /transport-vehicles/:id - Delete vehicle
GET /transport-vehicles/route/:routeId - Get vehicles by route
PUT /transport-vehicles/:id/status - Update vehicle status

transport-fee.routes.ts

GET /transport-fees - List all transport fees
GET /transport-fees/:id - Get fee details
POST /transport-fees - Create transport fee
PUT /transport-fees/:id - Update transport fee
GET /transport-fees/student/:studentId - Get fees for a student
PUT /transport-fees/:id/pay - Mark transport fee as paid
GET /transport-fees/pending - Get pending transport fees

Hostel Management
hostel.routes.ts

GET /hostels - List all hostels
GET /hostels/:id - Get hostel details
POST /hostels - Create new hostel
PUT /hostels/:id - Update hostel
DELETE /hostels/:id - Delete hostel
GET /hostels/:id/rooms - Get rooms in a hostel

hostel-room.routes.ts

GET /hostel-rooms - List all hostel rooms
GET /hostel-rooms/:id - Get room details
POST /hostel-rooms - Create new room
PUT /hostel-rooms/:id - Update room
DELETE /hostel-rooms/:id - Delete room
GET /hostel-rooms/hostel/:hostelId - Get rooms by hostel
GET /hostel-rooms/available - Get available rooms

hostel-allocation.routes.ts

GET /hostel-allocations - List all allocations
GET /hostel-allocations/:id - Get allocation details
POST /hostel-allocations - Create new allocation
PUT /hostel-allocations/:id - Update allocation
GET /hostel-allocations/student/:studentId - Get allocation for student
GET /hostel-allocations/room/:roomId - Get allocations for room
PUT /hostel-allocations/:id/vacate - Vacate room allocation

hostel-fee.routes.ts

GET /hostel-fees - List all hostel fees
GET /hostel-fees/:id - Get fee details
POST /hostel-fees - Create hostel fee
PUT /hostel-fees/:id - Update hostel fee
GET /hostel-fees/student/:studentId - Get fees for a student
PUT /hostel-fees/:id/pay - Mark hostel fee as paid
GET /hostel-fees/pending - Get pending hostel fees

System Configuration
settings.routes.ts

GET /settings - List all settings
GET /settings/:name - Get setting by name
PUT /settings/:name - Update setting
GET /settings/institution - Get institution settings
PUT /settings/institution - Update institution settings

institution.routes.ts

GET /institution - Get institution details
PUT /institution - Update institution details
PUT /institution/logo - Update institution logo

activity-log.routes.ts

GET /activity-logs - List activity logs
GET /activity-logs/:id - Get log details
GET /activity-logs/user/:userId - Get logs by user
GET /activity-logs/action/:action - Get logs by action type
GET /activity-logs/target/:target - Get logs by target
GET /activity-logs/date-range - Get logs in date range