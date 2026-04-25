import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { AppController } from "./app.controller";
import { PrismaService } from "./prisma/prisma.service";
import { UserModule } from "./modules/users/users.module";
import { RolesModule } from "./modules/roles/roles.module";
import { APP_INTERCEPTOR } from "@nestjs/core";
import { BigIntSerializerInterceptor } from "./common/interceptors/bigint-serializer.interceptor";
import { AuthModule } from "./modules/auth/auth.module";

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    UserModule,
    RolesModule,
    AuthModule,
  ],
  controllers: [AppController],
  providers: [
    PrismaService,
    {
      provide: APP_INTERCEPTOR,
      useClass: BigIntSerializerInterceptor,
    },
  ],
  exports: [PrismaService],
})
export class AppModule {}
