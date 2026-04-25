import { IsNumber, IsString } from "class-validator";

export class CreateCampusDto {
    @IsNumber()
    institute_id!: number;

    @IsString()
    name!: string;

    @IsString()
    code!: string;
}
