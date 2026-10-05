import Foundation

enum ErroPokeAPI: Error, LocalizedError {
    case urlInvalida
    case erroRede(Error)
    case respostaInvalida

    var errorDescription: String? {
        switch self {
        case .urlInvalida:
            return "A URL solicitada é inválida."
        case .erroRede(let erro):
            return "Falha na conexão de rede: \(erro.localizedDescription)"
        case .respostaInvalida:
            return "O servidor retornou uma resposta inválida."
        }
    }
}

struct RespostaListaPokeAPI: Decodable {
    let results: [LinkPokeAPI]
}

struct RespostaTipoPokeAPI: Decodable {
    let pokemon: [SlotPokemonTipoPokeAPI]
}

struct SlotPokemonTipoPokeAPI: Decodable {
    let pokemon: LinkPokeAPI
}

struct RespostaGrupoEspeciesPokeAPI: Decodable {
    let pokemonSpecies: [LinkPokeAPI]

    enum CodingKeys: String, CodingKey {
        case pokemonSpecies = "pokemon_species"
    }
}

struct RespostaDetalhesPokeAPI: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [SlotTipoPokeAPI]
    let stats: [StatPokeAPI]
    let abilities: [SlotHabilidadePokeAPI]
    let sprites: SpritesPokeAPI
}

struct SlotTipoPokeAPI: Decodable {
    let type: LinkPokeAPI
}

struct StatPokeAPI: Decodable {
    let baseStat: Int
    let stat: LinkPokeAPI

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct SlotHabilidadePokeAPI: Decodable {
    let ability: LinkPokeAPI
}

struct LinkPokeAPI: Decodable {
    let name: String
    let url: String
}

struct SpritesPokeAPI: Decodable {
    let other: OutrosSpritesPokeAPI?
}

struct OutrosSpritesPokeAPI: Decodable {
    let officialArtwork: ArteOficialPokeAPI?

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct ArteOficialPokeAPI: Decodable {
    let frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

class PokeAPIService {
    private let urlBase = "https://pokeapi.co/api/v2"

    func buscarPokemons(categoria: String, opcao: String, limite: Int = 15) async throws -> [PokemonModel] {
        let cat = categoria.lowercased()
        let op = opcao.lowercased()
        var links: [LinkPokeAPI] = []

        if cat.contains("tipo") {
            let url = URL(string: "\(urlBase)/type/\(op)")!
            let (dados, _) = try await URLSession.shared.data(from: url)
            let resultado = try JSONDecoder().decode(RespostaTipoPokeAPI.self, from: dados)
            links = resultado.pokemon.map { $0.pokemon }
        } else if cat.contains("cor") {
            let url = URL(string: "\(urlBase)/pokemon-color/\(op)")!
            let (dados, _) = try await URLSession.shared.data(from: url)
            let resultado = try JSONDecoder().decode(RespostaGrupoEspeciesPokeAPI.self, from: dados)
            links = resultado.pokemonSpecies
        } else if cat.contains("gera") || cat.contains("geração") {
            let url = URL(string: "\(urlBase)/generation/\(op)")!
            let (dados, _) = try await URLSession.shared.data(from: url)
            let resultado = try JSONDecoder().decode(RespostaGrupoEspeciesPokeAPI.self, from: dados)
            links = resultado.pokemonSpecies
        } else {
            let url = URL(string: "\(urlBase)/pokemon?limit=\(limite)")!
            let (dados, _) = try await URLSession.shared.data(from: url)
            let resultado = try JSONDecoder().decode(RespostaListaPokeAPI.self, from: dados)
            links = resultado.results
        }

        let linksLimitados = Array(links.prefix(limite))

        return try await withThrowingTaskGroup(of: PokemonModel?.self) { grupo in
            for item in linksLimitados {
                grupo.addTask {
                    let urlDetalhes = item.url.replacingOccurrences(of: "pokemon-species", with: "pokemon")
                    return try? await self.buscarResumoPokemon(urlTexto: urlDetalhes)
                }
            }

            var pokemons: [PokemonModel] = []
            for try await pokemon in grupo {
                if let pokemon { pokemons.append(pokemon) }
            }
            return pokemons.sorted { $0.id < $1.id }
        }
    }

    private func buscarResumoPokemon(urlTexto: String) async throws -> PokemonModel {
        guard let url = URL(string: urlTexto) else {
            throw ErroPokeAPI.urlInvalida
        }

        let (dados, _) = try await URLSession.shared.data(from: url)
        let detalhe = try JSONDecoder().decode(RespostaDetalhesPokeAPI.self, from: dados)

        let pontosVida = detalhe.stats.first(where: { $0.stat.name == "hp" })?.baseStat ?? 0
        let ataque = detalhe.stats.first(where: { $0.stat.name == "attack" })?.baseStat ?? 0
        let defesa = detalhe.stats.first(where: { $0.stat.name == "defense" })?.baseStat ?? 0
        let imagem = detalhe.sprites.other?.officialArtwork?.frontDefault ?? ""
        let tipos = detalhe.types.map { $0.type.name.capitalized }

        return PokemonModel(
            id: detalhe.id,
            nome: detalhe.name.capitalized,
            imagemURL: imagem,
            tipos: tipos,
            hp: pontosVida,
            ataque: ataque,
            defesa: defesa
        )
    }

    func obterDetalhesCompletos(id: Int) async throws -> PokemonModel {
        guard let url = URL(string: "\(urlBase)/pokemon/\(id)") else {
            throw ErroPokeAPI.urlInvalida
        }

        let (dados, _) = try await URLSession.shared.data(from: url)
        let detalhe = try JSONDecoder().decode(RespostaDetalhesPokeAPI.self, from: dados)

        let pontosVida = detalhe.stats.first(where: { $0.stat.name == "hp" })?.baseStat ?? 0
        let ataque = detalhe.stats.first(where: { $0.stat.name == "attack" })?.baseStat ?? 0
        let defesa = detalhe.stats.first(where: { $0.stat.name == "defense" })?.baseStat ?? 0
        let imagem = detalhe.sprites.other?.officialArtwork?.frontDefault ?? ""
        let tipos = detalhe.types.map { $0.type.name.capitalized }
        let habilidades = detalhe.abilities.map { $0.ability.name.capitalized }
        let alturaMetros = Double(detalhe.height) / 10.0
        let pesoQuilos = Double(detalhe.weight) / 10.0

        let estatisticas = detalhe.stats.map {
            EstatisticaModel(nome: formatarNomeEstatistica($0.stat.name), valor: $0.baseStat)
        }

        return PokemonModel(
            id: detalhe.id,
            nome: detalhe.name.capitalized,
            imagemURL: imagem,
            tipos: tipos,
            hp: pontosVida,
            ataque: ataque,
            defesa: defesa,
            altura: alturaMetros,
            peso: pesoQuilos,
            habilidades: habilidades,
            estatisticas: estatisticas
        )
    }

    private func formatarNomeEstatistica(_ nome: String) -> String {
        switch nome {
        case "hp": return "HP"
        case "attack": return "Ataque"
        case "defense": return "Defesa"
        case "special-attack": return "Atq. Especial"
        case "special-defense": return "Def. Especial"
        case "speed": return "Velocidade"
        default: return nome.capitalized
        }
    }
}
