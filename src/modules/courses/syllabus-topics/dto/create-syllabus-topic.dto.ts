import { Type } from "class-transformer";
import { IsInt, IsNumber, IsOptional, IsString, Min } from "class-validator";

export class CreateSyllabusTopicDto {
  @Type(() => Number)
  @IsInt()
  course_id!: number;

  @Type(() => Number)
  @IsInt()
  @Min(1)
  unit_number!: number;

  @IsString()
  title!: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  expected_hours?: number;
}
