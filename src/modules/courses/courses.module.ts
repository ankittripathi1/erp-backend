import { Module } from '@nestjs/common';
import { CoursesService } from './courses.service';
import { CoursesController } from './courses.controller';
import { ProgramCoursesModule } from './program-courses/program-courses.module';
import { CourseOfferingsModule } from './course-offerings/course-offerings.module';
import { SyllabusTopicsModule } from './syllabus-topics/syllabus-topics.module';
import { TeachingAssignmentsModule } from './teaching-assignments/teaching-assignments.module';

@Module({
  controllers: [CoursesController],
  providers: [CoursesService],
  imports: [
    ProgramCoursesModule,
    CourseOfferingsModule,
    SyllabusTopicsModule,
    TeachingAssignmentsModule,
  ],
})
export class CoursesModule {}
