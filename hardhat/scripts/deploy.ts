import { ethers } from 'hardhat';

async function main() {
  const rankersToken = await ethers.deployContract('RankersToken');
  await rankersToken.waitForDeployment();
  console.log('RankersToken Contract Deployed at ' + rankersToken.target);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});