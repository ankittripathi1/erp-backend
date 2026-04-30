import { Type } from "class-transformer";
import { IsInt, IsNumber, IsOptional, IsString } from "class-validator";

export class CreateGuardianDto {
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  user_id?: number;

  @IsString()
  name!: string;

  @IsString()
  relation!: string;

  @IsOptional()
  @IsString()
  occupation?: string;

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  annual_income?: number;

  @IsOptional()
  @IsString()
  phone?: string;

  @IsOptional()
  @IsString()
  email?: string;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  address_id?: number;
}
