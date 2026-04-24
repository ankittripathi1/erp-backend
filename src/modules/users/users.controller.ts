import { Controller, Get, Param } from "@nestjs/common";
import { UserService } from "./users.service";

@Controller("users")
export class UsersController {
  constructor(private readonly usersService: UserService) {}

  @Get()
  findMany() {
    return this.usersService.findMany();
  }

  @Get(":id")
  findOne(@Param("id") id: string) {
    return this.usersService.findOne(id);
  }
}
