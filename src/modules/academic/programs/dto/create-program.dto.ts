import { IsNumber, IsOptional, IsString } from "class-validator";

export class CreateProgramDto {
    @IsNumber()
    department_id!: number;

    @IsString()
    name!: string;

    @IsString()
    code!: string;

    @IsString()
    level!: string

    @IsNumber()
    duration_years!: number;

    @IsNumber()
    total_terms!: number;

    @IsOptional()
    @IsNumber()
    total_credits?: number;

    @IsOptional()
    @IsString()
    grading_scheme_id?: number;

    @IsOptional()
    @IsString()
    descrption?: string
}
