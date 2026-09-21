import SwiftUI

struct TelaRaizView: View {
    @State private var roteador = RoteadorNavegacao()

    var body: some View {
        NavigationStack(path: $roteador.caminho) {
            InicioView()
                .navigationDestination(for: Rota.self) { rota in
                    switch rota {
                    case .galeria:
                        GaleriaView()
                    case .detalhes(let idPokemon):
                        DetalhesView(idPokemon: idPokemon)
                    }
                }
        }
        .environment(roteador)
    }
}
