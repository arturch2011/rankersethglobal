/*
  Warnings:

  - You are about to drop the column `operator_address` on the `goal_staking_info` table. All the data in the column will be lost.
  - You are about to drop the column `transaction_id` on the `goal_staking_info` table. All the data in the column will be lost.
  - Added the required column `transaction_link` to the `goal_staking_info` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "goal_staking_info" DROP COLUMN "operator_address",
DROP COLUMN "transaction_id",
ADD COLUMN     "transaction_link" TEXT NOT NULL;
