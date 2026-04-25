import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { AppController } from "./app.controller";
import { UserModule } from "./modules/users/users.module";
import { RolesModule } from "./modules/roles/roles.module";
import { APP_INTERCEPTOR } from "@nestjs/core";
import { BigIntSerializerInterceptor } from "./common/interceptors/bigint-serializer.interceptor";
import { AuthModule } from "./modules/auth/auth.module";
import { InstitutesModule } from './modules/organization/institutes/institutes.module';
import { PrsimaModule } from "./prisma/prisma.module";
import { CampusesModule } from './modules/organization/campuses/campuses.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    PrsimaModule,
    UserModule,
    RolesModule,
    AuthModule,
    InstitutesModule,
    CampusesModule,
  ],
  controllers: [AppController],
  providers: [
    {
      provide: APP_INTERCEPTOR,
      useClass: BigIntSerializerInterceptor,
    },
  ],
})
export class AppModule { }
