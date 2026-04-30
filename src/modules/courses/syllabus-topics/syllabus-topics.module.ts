import { Module } from "@nestjs/common";
import { SyllabusTopicsController } from "./syllabus-topics.controller";
import { SyllabusTopicsService } from "./syllabus-topics.service";

@Module({
  controllers: [SyllabusTopicsController],
  providers: [SyllabusTopicsService],
})
export class SyllabusTopicsModule {}
