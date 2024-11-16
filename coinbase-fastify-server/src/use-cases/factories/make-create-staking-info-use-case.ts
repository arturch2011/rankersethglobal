
import { PrismaGoalStakingInfoRepository } from '@/repositories/prisma/prisma-goal-staking-info-repository'
import { CreateGoalStakingInfoUseCase } from '@/use-cases/goal-staking-info/create-goal-staking-info'

export function makeCreateGoalStakingInfoUseCase() {
  const goalStakingInfoRepository = new PrismaGoalStakingInfoRepository()
  const createGoalStakingInfoUseCase = new CreateGoalStakingInfoUseCase(goalStakingInfoRepository)

  return createGoalStakingInfoUseCase
}
