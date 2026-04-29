import {
  ArgumentsHost,
  Catch,
  ConflictException,
  ExceptionFilter,
  NotFoundException,
} from "@nestjs/common";
import { Prisma } from "generated/prisma/client";

@Catch(Prisma.PrismaClientKnownRequestError)
export class PrismaExceptionFilter<T> implements ExceptionFilter {
  catch(exception: Prisma.PrismaClientKnownRequestError, host: ArgumentsHost) {
    const response = host.switchToHttp().getResponse();

    if (exception.code === "P2002") {
      const error = new ConflictException(
        "A record with this value already exists.",
      );
      return response.status(error.getStatus()).send(error.getResponse());
    }

    if (exception.code === "P2025") {
      const error = new NotFoundException("Record not found.");
      return response.status(error.getStatus()).send(error.getResponse());
    }

    return response.status(500).send({
      statusCode: 500,
      message: "Database operation failed.",
      error: "Internal Server Error",
    });
  }
}
