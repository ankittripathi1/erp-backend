import { integer, varchar } from "drizzle-orm/pg-core";

export const userTable =
  ("users",
  {
    id: integer("id").primaryKey().generatedAlwaysAsIdentity(),
    name: varchar({ length: 255 }).notNull(),
    email: varchar({ length: 255 }).notNull().unique(),
    password: varchar({ length: 255 }).notNull(),
  });
