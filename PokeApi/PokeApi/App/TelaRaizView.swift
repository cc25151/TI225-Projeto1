import SwiftUI

struct TelaRaizView: View {
    @State private var roteador = RoteadorNavegacao()

    var body: some View {
        NavigationStack(path: $roteador.caminho) {
            InicioView()
                .navigationDestination(for: Rota.self) { rota in
                    switch rota {
                    case .galeria(let categoria):
                        GaleriaView(categoria: categoria)
                    case .detalhes(let pokemon):
                        DetalhesView(pokemon: pokemon)
                    case .inicio:
                        InicioView()
                    }
                }
        }
        .environment(roteador)
    }
}
