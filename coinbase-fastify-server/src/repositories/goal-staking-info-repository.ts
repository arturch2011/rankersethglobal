import { GoalStakingInfo, Prisma } from '@prisma/client'

export interface GoalStakingInfoRepository {
  findById(goalId: number): Promise<GoalStakingInfo | null>
  create(data: Prisma.GoalStakingInfoCreateInput): Promise<GoalStakingInfo>
}
