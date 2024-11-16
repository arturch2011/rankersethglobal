-- CreateTable
CREATE TABLE "goal_staking_info" (
    "id" SERIAL NOT NULL,
    "goal_id" INTEGER NOT NULL,
    "staked_amount" DECIMAL(65,30) NOT NULL,
    "asset" TEXT NOT NULL,
    "chain" TEXT NOT NULL,
    "transaction_id" TEXT NOT NULL,
    "operator_address" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "goal_staking_info_pkey" PRIMARY KEY ("id")
);
