import Foundation

enum Rota: Hashable {
    case inicio
    case galeria(categoria: String)
    case detalhes(pokemon: PokemonModel)
}
