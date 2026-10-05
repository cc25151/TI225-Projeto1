import Foundation

struct Pokemon: Identifiable, Hashable {
    let id: Int
    let nome: String
    let imagemURL: String
    let tipos: [String]
    let hp: Int
    let ataque: Int
    let defesa: Int
    
    var numeroFormatado: String {
        String(format: "#%03d", id)
    }
}

struct PokeAPIListResponse: Codable {
    let results: [PokeAPILink]
}

struct PokeAPILink: Codable {
    let name: String
    let url: String
}

struct PokeAPIDetailResponse: Codable {
    let id: Int
    let name: String
    let stats: [PokeAPIStat]
    let types: [PokeAPITypeSlot]
    let sprites: PokeAPISprites
}

struct PokeAPIStat: Codable {
    let baseStat: Int
    let stat: PokeAPILink

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct PokeAPITypeSlot: Codable {
    let type: PokeAPILink
}

struct PokeAPISprites: Codable {
    let other: PokeAPIOtherSprites?
    
    struct PokeAPIOtherSprites: Codable {
        let officialArtwork: PokeAPIOfficialArtwork?
        
        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }
    }
    
    struct PokeAPIOfficialArtwork: Codable {
        let frontDefault: String?
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
}

struct EstatisticaModel: Hashable {
    let nome: String
    let valor: Int
}

struct PokemonModel: Identifiable, Hashable {
    let id: Int
    let nome: String
    let imagemURL: String
    let tipos: [String]
    let hp: Int
    let ataque: Int
    let defesa: Int
    var altura: Double = 0.0
    var peso: Double = 0.0
    var habilidades: [String] = []
    var estatisticas: [EstatisticaModel] = []

    var numeroFormatado: String {
        String(format: "#%03d", id)
    }
}
