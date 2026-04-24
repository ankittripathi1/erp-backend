import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { AppController } from "./app.controller";
import { PrismaService } from "./prisma/prisma.service";
import { UserModule } from "./modules/users/users.module";
import { RolesModule } from "./modules/roles/roles.module";

@Module({
  imports: [ConfigModule.forRoot({ isGlobal: true }), UserModule, RolesModule],
  controllers: [AppController],
  providers: [PrismaService],
  exports: [PrismaService],
})
export class AppModule {}
