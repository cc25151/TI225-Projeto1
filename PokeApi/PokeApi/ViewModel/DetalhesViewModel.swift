import SwiftUI

@Observable
final class DetalhesViewModel {
    let idPokemon: Int

    init(idPokemon: Int) {
        self.idPokemon = idPokemon
    }
}
