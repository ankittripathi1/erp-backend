import { Module } from '@nestjs/common';
import { ProgramCoursesService } from './program-courses.service';
import { ProgramCoursesController } from './program-courses.controller';

@Module({
  controllers: [ProgramCoursesController],
  providers: [ProgramCoursesService],
})
export class ProgramCoursesModule {}
