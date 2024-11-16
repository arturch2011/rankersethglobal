import { prisma } from '@/lib/prisma'
import { Prisma } from '@prisma/client'

import { GoalStakingInfoRepository } from '../goal-staking-info-repository'

export class PrismaGoalStakingInfoRepository implements GoalStakingInfoRepository {
  async findById(goalId: number) {
    const order = await prisma.goalStakingInfo.findUnique({
      where: {
        goal_id: goalId,
      },
    })
    return order
  }
  async create(data: Prisma.GoalStakingInfoCreateInput) {
    const order = await prisma.goalStakingInfo.create({
      data,
    })
    return order
  }
}