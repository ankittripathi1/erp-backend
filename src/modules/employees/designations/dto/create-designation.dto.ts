import { IsString } from "class-validator";

export class CreateDesignationDto {
  @IsString()
  name!: string;

  @IsString()
  category!: string;
}
