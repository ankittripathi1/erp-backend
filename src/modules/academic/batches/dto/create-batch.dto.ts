import { IsNumber, IsOptional, IsString } from "class-validator";

export class CreateBatchDto {
    @IsNumber()
    program_id!: number;

    @IsString()
    name!: string;

    @IsNumber()
    start_year!: number;

    @IsNumber()
    end_year!: number;

    @IsOptional()
    @IsNumber()
    max_strength?: number;
}
