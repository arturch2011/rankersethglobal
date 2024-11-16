import { FastifyReply, FastifyRequest } from 'fastify'
import { Wallet } from "@coinbase/coinbase-sdk";
import { coinbase } from '../../lib/coinbase';

export async function createWallet(request: FastifyRequest, reply: FastifyReply) {
  try {
    coinbase();
    let wallet = await Wallet.create();
    console.log(`Wallet successfully created: `, wallet.toString());

    // Wallets come with a single default Address, accessible via getDefaultAddress:
    let address = await wallet.getDefaultAddress();
    console.log(`Default address for the wallet: `, address.toString());

    return { hello: "world" }

  } catch (error: unknown) {
    console.error(error)
    if (error instanceof Error) {
    return { error: error.message }
  }

  }

}