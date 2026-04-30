import { PartialType } from "@nestjs/mapped-types";
import { CreateSyllabusTopicDto } from "./create-syllabus-topic.dto";

export class UpdateSyllabusTopicDto extends PartialType(
  CreateSyllabusTopicDto,
) {}
