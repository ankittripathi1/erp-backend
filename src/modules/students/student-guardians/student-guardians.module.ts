import { Module } from '@nestjs/common';
import { StudentGuardiansController } from './student-guardians.controller';
import { StudentGuardiansService } from './student-guardians.service';

@Module({
  controllers: [StudentGuardiansController],
  providers: [StudentGuardiansService]
})
export class StudentGuardiansModule {}
