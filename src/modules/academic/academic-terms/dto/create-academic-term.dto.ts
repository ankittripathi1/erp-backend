import { IsBoolean, IsDateString, IsNumber, IsOptional, IsString } from "class-validator";

export class CreateAcademicTermDto {
    @IsNumber()
    academic_year_id!: number;

    @IsString()
    name!: string;

    @IsString()
    term_type!: string;

    @IsOptional()
    @IsDateString()
    start_date?: string;

    @IsOptional()
    @IsDateString()
    end_date?: string;

    @IsOptional()
    @IsBoolean()
    is_current?: boolean;
}
