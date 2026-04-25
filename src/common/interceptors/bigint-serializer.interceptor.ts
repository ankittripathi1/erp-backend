import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from "@nestjs/common";
import { map, Observable } from "rxjs";

function SerializeBigInt(value: unknown): unknown {
  if (typeof value === "bigint") {
    return value.toString();
  }

  if (Array.isArray(value)) {
    return value.map((item) => SerializeBigInt(item));
  }

  if (value && typeof value == "object") {
    return Object.fromEntries(
      Object.entries(value).map(([key, item]) => [key, SerializeBigInt(item)]),
    );
  }

  return value;
}

@Injectable()
export class BigIntSerializerInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    return next.handle().pipe(map((value) => SerializeBigInt(value)));
  }
}
