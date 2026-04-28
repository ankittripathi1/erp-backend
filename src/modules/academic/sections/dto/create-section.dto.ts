import { IsNumber, IsOptional, IsString } from "class-validator";

export class CreateSectionDto {
    @IsNumber()
    batch_id!: number;

    @IsNumber()
    term_id!: number;

    @IsString()
    name!: string;

    @IsOptional()
    @IsNumber()
    class_teacher_id?: number;

    @IsOptional()
    @IsNumber()
    max_strength?: number
}
