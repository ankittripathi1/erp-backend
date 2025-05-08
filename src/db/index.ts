import { drizzle } from "drizzle-orm/singlestore/driver";

const db = drizzle(process.env.DATABASE_URL);
