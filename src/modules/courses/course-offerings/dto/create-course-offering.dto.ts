import { Type } from "class-transformer";
import { IsInt, IsOptional, Min } from "class-validator";

export class CreateCourseOfferingDto {
  @Type(() => Number)
  @IsInt()
  course_id!: number;

  @Type(() => Number)
  @IsInt()
  term_id!: number;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  section_id?: number;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  primary_teacher_id?: number;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  room_id?: number;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  capacity?: number;
}
