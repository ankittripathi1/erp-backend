import { Type } from "class-transformer";
import { IsBoolean, IsInt, IsOptional, Min } from "class-validator";

export class CreateProgramCourseDto {
  @Type(() => Number)
  @IsInt()
  program_id!: number;

  @Type(() => Number)
  @IsInt()
  course_id!: number;

  @Type(() => Number)
  @IsInt()
  @Min(1)
  term_number!: number;

  @IsOptional()
  @IsBoolean()
  is_mandatory?: boolean;
}
