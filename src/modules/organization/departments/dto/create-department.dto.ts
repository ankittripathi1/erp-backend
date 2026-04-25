import { IsNumber, IsOptional, IsString } from "class-validator";

export class CreateDepartmentDto {
    @IsNumber()
    school_id!: number;

    @IsString()
    name!: string;

    @IsString()
    code!: string;

    @IsOptional()
    @IsNumber()
    hod_id?: number;
}
