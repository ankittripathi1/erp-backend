export const AppRole = {
  SUPER_ADMIN: "SUPER_ADMIN",
  ADMIN: "ADMIN",
  FACULTY: "FACULTY",
  STAFF: "STAFF",
  STUDENT: "STUDENT",
  ACCOUNTANT: "ACCOUNTANT",
  LIBRARIAN: "LIBRARIAN",
  HR: "HR",
} as const;

export type AppRole = (typeof AppRole)[keyof typeof AppRole];
