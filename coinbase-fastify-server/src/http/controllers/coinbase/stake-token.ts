import { coinbase } from "@/http/lib/coinbase";
import { Coinbase, Wallet, ExternalAddress, StakeOptionsMode } from "@coinbase/coinbase-sdk";
import { FastifyReply, FastifyRequest } from "fastify";

/**
 * Perform a stake operation.
 */
export async function stake(request: FastifyRequest, reply: FastifyReply) {
  const { user, amount, asset } = request.body as { user: { walletId: string, seed: string }, amount: number, asset: string };

  coinbase()

  let importedWallet = await Wallet.import(user);
  let { id } = await importedWallet.getDefaultAddress();
  console.log(`Default address for the wallet: `, id);


  // Create a new external address on the ethereum-holesky testnet network.
  const stakingWallet = new ExternalAddress(Coinbase.networks.EthereumHolesky, id);

  // Get the stakeable balance of the wallet.
  const stakeableBalance = await stakingWallet.stakeableBalance(asset);
  console.log("Done.");
  console.log(`Stakeable balance of wallet: ${stakeableBalance} ${asset.toUpperCase()}`);


  const stakingOperation = await stakingWallet.buildStakeOperation(amount, asset, StakeOptionsMode.PARTIAL);

  return {
    result: "success",
    transactionLink: stakingOperation.getTransactions()[0].getTransactionLink(),
    stakingOperation,
  }
}