import { Router } from "express";
import { authenticate } from "../middlewares/authenticate";
import { hasPermission } from "../middlewares/checkPermission.middleware";
import { deleteUser, getUserById, getUserPermissions, getUsers, updateUser, updateUserPermissions, updateUserRole } from "../controllers/user.controller";

const userRoutes = Router();

userRoutes.get("/users",authenticate,hasPermission("canViewUsers"), getUsers);
userRoutes.get("/:id",authenticate,hasPermission("canViewUsers"), getUserById);
// userRoutes.post("/",authenticate,hasPermission("canCreateUsers"), createUser); // not creating useing wrapper api.

userRoutes.put("/:id", authenticate, hasPermission("canUpdateUsers"), updateUser);
userRoutes.put("/:id/delete", authenticate, hasPermission("canDeleteUsers"), deleteUser); // soft delete
userRoutes.put("/:id/role", authenticate, hasPermission("canDeleteUsers"), updateUserRole); // soft delete

userRoutes.get("/:id/permissions", authenticate, hasPermission("canViewUsers"), getUserPermissions); 

userRoutes.put("/:id/permissions", authenticate, hasPermission("canUpdateUsers"), updateUserPermissions);

export default userRoutes;