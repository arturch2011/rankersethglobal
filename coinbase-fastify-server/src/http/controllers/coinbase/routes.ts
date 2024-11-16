import { FastifyInstance } from 'fastify'
import { createWallet } from './create-wallet';

export async function CoinbaseRoutes(app: FastifyInstance) {
  app.get("/coinbase", createWallet)
}
