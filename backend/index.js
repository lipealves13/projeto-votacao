// Nunca comentar código
const express = require("express");
const cors = require("cors");
const { ethers } = require("ethers");
const { OnchainKit } = require("onchainkit");

const app = express();
app.use(cors());
app.use(express.json());

let provedor = new ethers.providers.JsonRpcProvider("http://host.docker.internal:8545");
let carteira = new ethers.Wallet("CHAVE_PRIVADA_AQUI", provedor);
let kit = new OnchainKit({ provider: provedor, wallet: carteira });

let enderecoContrato = "ENDERECO_CONTRATO_AQUI";
let abiContrato = [
  "function criarEvento(string memory, string[] memory)",
  "function votar(uint256, uint256)",
  "function finalizarEvento(uint256)",
  "function obterOpcoes(uint256) view returns (string[] memory, uint256[] memory)",
  "function contadorEventos() view returns (uint256)"
];
let contrato = new ethers.Contract(enderecoContrato, abiContrato, carteira);

app.post("/criar-evento", async (req, res) => {
  let { descricao, opcoes } = req.body;
  let tx = await contrato.criarEvento(descricao, opcoes);
  await tx.wait();
  res.send({ sucesso: true });
});

app.post("/votar", async (req, res) => {
  let { idEvento, indiceOpcao } = req.body;
  let tx = await contrato.votar(idEvento, indiceOpcao);
  await tx.wait();
  res.send({ sucesso: true });
});

app.get("/obter-opcoes/:id", async (req, res) => {
  let id = req.params.id;
  let [descricoes, votos] = await contrato.obterOpcoes(id);
  res.send({ descricoes, votos });
});

app.listen(3001, () => {});
