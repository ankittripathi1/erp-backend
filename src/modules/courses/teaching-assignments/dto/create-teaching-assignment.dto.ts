import { Type } from "class-transformer";
import { IsInt, IsString } from "class-validator";

export class CreateTeachingAssignmentDto {
  @Type(() => Number)
  @IsInt()
  offering_id!: number;

  @Type(() => Number)
  @IsInt()
  employee_id!: number;

  @IsString()
  role!: string;
}
