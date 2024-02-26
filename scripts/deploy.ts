import { ethers } from "hardhat";

async function main() {
  const [owner] = await ethers.getSigners();

  const token = await ethers.deployContract('T3dns', owner);
  await token.waitForDeployment();

  const holder = await ethers.deployContract('Holder', owner);
  await holder.waitForDeployment();

  const ownable = await ethers.deployContract('Owner', owner);
  await ownable.waitForDeployment();
  
  const domain = await ethers.deployContract('DomainLinked', owner);
  await domain.waitForDeployment();

  const sdomain = await ethers.deployContract('SDomainLinked', owner);
  await sdomain.waitForDeployment();

  const voteSystem = await ethers.deployContract('VoteSystem', owner);
  await voteSystem.waitForDeployment();

  const tokenAddress = await token.getAddress();

  const holderTx = await holder.set_token_address(tokenAddress);
  await holderTx.wait(1);

  // const balance = await token.balanceOf(await owner.getAddress());

  const addDomainTx = await domain.addDomain('com', 'banana');
  await addDomainTx.wait(1);

  const addDomainTx2 = await domain.addDomain('com', 'test');
  await addDomainTx2.wait(1);

  const domains = await domain.index(0, 1);
  const owenedDomains = await domain.getDomains();

  console.log(domains, owenedDomains);

  // const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  // const unlockTime = currentTimestampInSeconds + 60;

  // const lockedAmount = ethers.parseEther("0.001");

  // const lock = await ethers.deployContract("Lock", [unlockTime], {
  //   value: lockedAmount,
  // });

  // await lock.waitForDeployment();

  // console.log(
  //   `Lock with ${ethers.formatEther(
  //     lockedAmount
  //   )}ETH and unlock timestamp ${unlockTime} deployed to ${lock.target}`
  // );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
