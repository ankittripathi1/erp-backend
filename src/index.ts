import express from "express";
import authRoutes from "./routes/auth.route";
import cookieParser from "cookie-parser";
import userRoutes from "./routes/user.route";
import studentRoutes from "./routes/student.route";

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(cookieParser());

app.use("/api/v1/auth", authRoutes);
app.use("/api/v1/user", userRoutes);
app.use("/api/v1/stduents", studentRoutes)

app.get("/", (req: express.Request, res: express.Response) => {
  res.send("Hello World!");
});

app.listen(4000, () => {
  console.log("Server is running on port 4000");
});

