/*
  Warnings:

  - Added the required column `password` to the `core_user` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "core_user" ADD COLUMN     "password" TEXT NOT NULL;
