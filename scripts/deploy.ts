import { ethers } from "hardhat";

async function main() {
  // WALLET
  const [owner, client1] = await ethers.getSigners();

  // TOKEN
  const token = await ethers.deployContract('T3dns', owner);
  await token.waitForDeployment();
  const tokenAddress = await token.getAddress();

  const mintTx = await token.mint(await client1.getAddress(), 1e12);
  await mintTx.wait(1);
  
  // DOMAIN
  const domain = await ethers.deployContract('DomainLinked', [tokenAddress], owner);
  await domain.waitForDeployment();

  // SUBDOMAIN
  const sdomain = await ethers.deployContract('SDomainLinked', [tokenAddress], owner);
  await sdomain.waitForDeployment();

  // SYSTEM VOTE
  const voteSystem = await ethers.deployContract('VoteSystem', [tokenAddress], owner);
  await voteSystem.waitForDeployment();

  // REGISTER DOMAIN
  const addDomainTx = await domain.addDomain('com', 'banana');
  await addDomainTx.wait(1);
  const addDomainFor2 = await domain.connect(client1).addDomain('com', 'banana2');
  await addDomainFor2.wait(1);

  // LIST DOMAIN
  const domains = await domain.index(0, 1);
  const owenedDomains = await domain.getDomains();

  // REGISTER SUBDOMAIN
  const addSubdomainOwner = await sdomain.addSubDomain('com', 'banana', 'test');
  await addSubdomainOwner.wait(1);

  const addSubdomainClient = await sdomain.connect(client1).addSubDomain('com', 'banana2', 'test1');
  await addSubdomainClient.wait(1);

  // const subdomains = await sdomain.index(0, 1);
  // const addedSDomains = await sdomain.getSubDomains('com', 'banana');

  // REGISTER  PROPOSAL
  const rightToVote2 = await voteSystem.connect(client1).giveRightToVote(await client1.getAddress());
  await rightToVote2.wait(1);

  const proposal = {
    name: 'first proposal',
    description: '',
    voteCount: 0,
    ended: false,
  };

  const txProposal = await voteSystem.registerProposal(proposal);
  await txProposal.wait(1);

  // VOTE PROPOSAL
  const txVote = await voteSystem.connect(client1).vote(proposal);
  txVote.wait(1);

  // FINALIZE VOTING
  const winningProposal = await voteSystem.winningProposal(proposal.name);
  winningProposal.wait(1);

  // VOTING RESULT
  const proposals = await voteSystem.index(0, 0);
  console.log(proposals);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
