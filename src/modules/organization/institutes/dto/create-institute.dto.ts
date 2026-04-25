import { IsDateString, IsEmail, IsOptional, IsString, IsUrl } from "class-validator";

export class CreateInstituteDto {
    @IsString()
    name: string;

    @IsString()
    short_code: string;

    @IsOptional()
    @IsDateString()
    established_on?: string;

    @IsOptional()
    @IsString()
    logo?: string;

    @IsOptional()
    @IsUrl()
    website?: string;

    @IsOptional()
    @IsEmail()
    email?: string;

    @IsOptional()
    @IsString()
    phone?: string;
}
