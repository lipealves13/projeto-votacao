// Nunca comentar código
// Nomear variáveis e classes em português
pragma solidity ^0.8.0;

contract ContratoVotacao {
    struct Opcao {
        string descricao;
        uint256 votos;
    }

    struct Evento {
        string descricao;
        Opcao[] opcoes;
        bool finalizado;
        mapping(address => bool) jaVotou;
    }

    mapping(uint256 => Evento) public eventos;
    uint256 public contadorEventos;

    function criarEvento(string memory descricao, string[] memory descricoesOpcoes) public {
        contadorEventos++;
        for (uint256 i = 0; i < descricoesOpcoes.length; i++) {
            eventos[contadorEventos].opcoes.push(Opcao(descricoesOpcoes[i], 0));
        }
        eventos[contadorEventos].descricao = descricao;
    }

    function votar(uint256 idEvento, uint256 indiceOpcao) public {
        require(idEvento <= contadorEventos && idEvento > 0);
        require(!eventos[idEvento].finalizado);
        require(!eventos[idEvento].jaVotou[msg.sender]);
        require(indiceOpcao < eventos[idEvento].opcoes.length);
        eventos[idEvento].opcoes[indiceOpcao].votos++;
        eventos[idEvento].jaVotou[msg.sender] = true;
    }

    function finalizarEvento(uint256 idEvento) public {
        require(idEvento <= contadorEventos && idEvento > 0);
        require(!eventos[idEvento].finalizado);
        eventos[idEvento].finalizado = true;
    }

    function obterOpcoes(uint256 idEvento) public view returns (string[] memory, uint256[] memory) {
        require(idEvento <= contadorEventos && idEvento > 0);
        uint256 tamanho = eventos[idEvento].opcoes.length;
        string[] memory descricoes = new string[](tamanho);
        uint256[] memory votos = new uint256[](tamanho);
        for (uint256 i = 0; i < tamanho; i++) {
            descricoes[i] = eventos[idEvento].opcoes[i].descricao;
            votos[i] = eventos[idEvento].opcoes[i].votos;
        }
        return (descricoes, votos);
    }
}
