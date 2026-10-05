import SwiftUI

@Observable
class GaleriaViewModel {
    var pokemons: [PokemonModel] = []
    var carregando: Bool = false
    var mensagemErro: String? = nil

    var opcoesDisponiveis: [String] = []
    var opcaoSelecionada: String = ""

    private let servico: PokeAPIService

    init(servico: PokeAPIService = PokeAPIService()) {
        self.servico = servico
    }

    func inicializarOpcoes(para categoria: String) {
        let cat = categoria.lowercased()

        if cat.contains("tipo") {
            opcoesDisponiveis = ["fire", "water", "grass", "electric", "psychic", "dragon", "ghost"]
        } else if cat.contains("cor") {
            opcoesDisponiveis = ["red", "blue", "green", "yellow", "black", "white", "purple"]
        } else if cat.contains("gera") || cat.contains("geração") {
            opcoesDisponiveis = ["1", "2", "3", "4", "5"]
        } else {
            opcoesDisponiveis = []
        }

        if let primeira = opcoesDisponiveis.first {
            opcaoSelecionada = primeira
        }
    }

    @MainActor
    func carregarPokemons(categoria: String) async {
        guard !opcaoSelecionada.isEmpty else { return }

        carregando = true
        mensagemErro = nil

        do {
            pokemons = try await servico.buscarPokemons(categoria: categoria, opcao: opcaoSelecionada)
        } catch {
            mensagemErro = "Não foi possível carregar os Pokémon: \(error.localizedDescription)"
        }

        carregando = false
    }
}
