import { IsNumber, IsOptional, IsString } from "class-validator";

export class CreateSchoolDto {
    @IsNumber()
    campus_id!: number

    @IsString()
    name!: string;

    @IsString()
    code!: string;

    @IsOptional()
    @IsNumber()
    dean_id?: number;
}
