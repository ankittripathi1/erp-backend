import { Router } from "express";
import { authenticate } from "../middlewares/authenticate";
import { hasPermission } from "../middlewares/checkPermission.middleware";
import { createStudent, getAllStudents, getStudentById } from "../controllers/student.controller";

const studentRoutes = Router();

studentRoutes.get("/", authenticate, hasPermission("canViewStudents"), getAllStudents);
studentRoutes.get("/:id", authenticate, hasPermission("canViewStudents"), getStudentById);

studentRoutes.post("/", authenticate, hasPermission("canCreateStudents"), createStudent); 

// - [ ] POST /students - Create new student
// - [ ] PUT /students/:id - Update student information
// - [ ] DELETE /students/:id - Delete student record
// - [ ] GET /students/batch/:batchId - Get students by batch
// - [ ] GET /students/search - Search students by criteria
// - [ ] GET /students/:id/academic-history - Get student academic history
// - [ ] GET /students/:id/attendance - Get student attendance record
// - [ ] GET /students/:id/exam-scores - Get student exam scores
// - [ ] GET /students/:id/fees - Get student fees information

export default studentRoutes;