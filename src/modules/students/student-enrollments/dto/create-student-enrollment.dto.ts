import { Type } from 'class-transformer';
import { IsDateString, IsInt, IsNotEmpty, IsString } from 'class-validator';

export class CreateStudentEnrollmentDto {
  @Type(() => Number)
  @IsInt()
  @IsNotEmpty()
  student_id!: number;

  @Type(() => Number)
  @IsInt()
  @IsNotEmpty()
  offering_id!: number;

  @IsDateString()
  @IsNotEmpty()
  enrolled_on!: string;

  @IsString()
  @IsNotEmpty()
  status!: string;
}
