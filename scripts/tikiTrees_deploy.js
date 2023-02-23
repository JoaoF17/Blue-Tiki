const hre = require("hardhat");

async function main() {

  const TikiTrees = await hre.ethers.getContractFactory("TikiTrees");
  const tikitrees = await TikiTrees.deploy();

  await tikitrees.deployed();

  console.log(
    `TikiTrees deployed to ${tikitrees.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
