import SwiftUI

@Observable
class DetalhesViewModel {
    var pokemonDetalhado: PokemonModel?
    var carregando: Bool = false
    var mensagemErro: String? = nil

    private let servico: PokeAPIService

    init(servico: PokeAPIService = PokeAPIService()) {
        self.servico = servico
    }

    @MainActor
    func carregarDetalhes(pokemon: PokemonModel) async {
        carregando = true
        mensagemErro = nil

        do {
            pokemonDetalhado = try await servico.obterDetalhesCompletos(id: pokemon.id)
        } catch {
            mensagemErro = "Não foi possível carregar os detalhes: \(error.localizedDescription)"
        }

        carregando = false
    }
}
