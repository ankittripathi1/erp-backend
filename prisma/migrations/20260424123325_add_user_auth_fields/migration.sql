/*
  Warnings:

  - A unique constraint covering the columns `[username]` on the table `core_user` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `username` to the `core_user` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "core_user" ADD COLUMN     "first_name" TEXT NOT NULL DEFAULT '',
ADD COLUMN     "is_staff" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "is_superuser" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "last_login" TIMESTAMP(3),
ADD COLUMN     "last_name" TEXT NOT NULL DEFAULT '',
ADD COLUMN     "username" TEXT NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "core_user_username_key" ON "core_user"("username");
