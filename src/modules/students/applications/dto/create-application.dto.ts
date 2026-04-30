import { Type } from "class-transformer";
import { IsDateString, IsInt, IsNumber, IsOptional, IsString } from "class-validator";

export class CreateApplicationDto {
  @IsString()
  application_no!: string;

  @Type(() => Number)
  @IsInt()
  program_id!: number;

  @IsString()
  first_name!: string;

  @IsString()
  last_name!: string;

  @IsString()
  email!: string;

  @IsString()
  phone!: string;

  @IsOptional()
  @IsDateString()
  date_of_birth?: string;

  @IsOptional()
  @IsString()
  gender?: string;

  @IsOptional()
  @IsString()
  previous_qualification?: string;

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  previous_percentage?: number;

  @IsOptional()
  @IsString()
  entrance_exam?: string;

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  entrance_score?: number;

  @IsString()
  status!: string;

  @IsDateString()
  applied_on!: string;

  @IsOptional()
  @IsDateString()
  decision_on?: string;
}
