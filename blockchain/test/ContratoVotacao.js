// Nunca comentar código
const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("ContratoVotacao", function () {
  let contrato;
  beforeEach(async function() {
    const Fabrica = await ethers.getContractFactory("ContratoVotacao");
    contrato = await Fabrica.deploy();
    await contrato.deployed();
  });

  it("Deve criar um evento e votar", async function() {
    await contrato.criarEvento("EventoTeste", ["Opcao1", "Opcao2"]);
    await contrato.votar(1, 0);
    const [descricoes, votos] = await contrato.obterOpcoes(1);
    expect(descricoes[0]).to.equal("Opcao1");
    expect(votos[0]).to.equal(1);
  });
});
