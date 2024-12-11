// Nunca comentar código
const { ethers } = require("hardhat");

async function main() {
  const Fabrica = await ethers.getContractFactory("ContratoVotacao");
  const contrato = await Fabrica.deploy();
  await contrato.waitForDeployment();
  console.log(await contrato.getAddress());
}

main();
