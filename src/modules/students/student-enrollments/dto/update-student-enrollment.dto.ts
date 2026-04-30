import { PartialType } from '@nestjs/mapped-types';
import { CreateStudentEnrollmentDto } from './create-student-enrollment.dto';
import { IsBoolean, IsOptional } from 'class-validator';

export class UpdateStudentEnrollmentDto extends PartialType(CreateStudentEnrollmentDto) {
  @IsOptional()
  @IsBoolean()
  is_active?: boolean;
}
