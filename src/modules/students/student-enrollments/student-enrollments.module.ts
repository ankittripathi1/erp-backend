import { Module } from '@nestjs/common';
import { StudentEnrollmentsController } from './student-enrollments.controller';
import { StudentEnrollmentsService } from './student-enrollments.service';
import { PrismaModule } from 'src/prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  controllers: [StudentEnrollmentsController],
  providers: [StudentEnrollmentsService]
})
export class StudentEnrollmentsModule {}
