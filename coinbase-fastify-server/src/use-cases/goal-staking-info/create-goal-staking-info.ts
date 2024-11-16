

import { GoalStakingInfoRepository } from '@/repositories/goal-staking-info-repository'
import { GoalStakingInfo } from '@prisma/client'


interface CreateGoalStakingInfoUseCaseRequest {
  goal_id: number
  staked_amount: number
  asset: string
  chain: string
  transaction_link: string
}

interface CreateGoalStakingInfoUseCaseResponse {
  goalStakingInfo: GoalStakingInfo
}

export class CreateGoalStakingInfoUseCase {
  constructor(
    private goalStakingInfoRepository: GoalStakingInfoRepository,
  ) {}

  async execute({
    goal_id,
    staked_amount,
    asset,
    chain,
    transaction_link,
  }: CreateGoalStakingInfoUseCaseRequest): Promise<CreateGoalStakingInfoUseCaseResponse> {

    const goal = await this.goalStakingInfoRepository.findById(goal_id)

    if (goal) {
      throw new Error('Goal aready has staking info')
    }

    const goalStakingInfo = await this.goalStakingInfoRepository.create({
      goal_id,
      staked_amount,
      asset,
      chain,
      transaction_link,
    })

    return { goalStakingInfo }
  }
}
