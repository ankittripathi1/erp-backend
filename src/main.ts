import { NestFactory } from "@nestjs/core";
import {
  FastifyAdapter,
  NestFastifyApplication,
} from "@nestjs/platform-fastify";
import "reflect-metadata";
import { AppModule } from "./app.module";
import helmet from "@fastify/helmet";
import rateLimit from "@fastify/rate-limit";
import { Logger, ValidationPipe } from "@nestjs/common";

async function bootstrap() {
  const logger = new Logger("Bootstrap");

  const app = await NestFactory.create<NestFastifyApplication>(
    AppModule,
    new FastifyAdapter(),
  );

  await app.register(helmet);

  app.register(rateLimit, {
    max: Number(process.env.RATE_LIMIT_MAX ?? 100),
    timeWindow: "1 minute",
  });

  const coresOrigin = process.env.CORE_ORIGIN ?? "https://localhost:3000";
  const origins = coresOrigin.split(",").map((origin) => origin.trim());
  app.enableCors({
    origin: origins,
    credentials: true,
  });

  app.setGlobalPrefix("api");
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: {
        enableImplicitConversion: true,
      },
    }),
  );

  const port = Number(process.env.PORT ?? 8000);

  await app.listen(port, "0.0.0.0");

  logger.log(`UMS backend running on http://localhost:${port}/api`);
}

bootstrap();
