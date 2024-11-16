/*
  Warnings:

  - A unique constraint covering the columns `[goal_id]` on the table `goal_staking_info` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "goal_staking_info_goal_id_key" ON "goal_staking_info"("goal_id");
