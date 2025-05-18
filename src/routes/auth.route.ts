import { Router } from "express";
import { getMe, loginController, logout, register } from "../controllers/auth.controller";
import { validate } from "../middlewares/validationMiddleware";
import { loginSchema, registerSchema } from "../validation/auth.validation";
import { authenticate } from "../middlewares/authenticate";

const router = Router();


router.post("/login", validate(loginSchema), loginController);
router.post("/register",validate(registerSchema), register);
router.post("/logout",logout);
// router.post("/forgot-password")
// router.post("/reset-password")

router.get("/me" , authenticate, getMe )
// router.get("/verify-token")

// router.put("/change-password")

export default router;