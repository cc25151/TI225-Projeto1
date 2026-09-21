import SwiftUI

struct DetalhesView: View {
    @Environment(RoteadorNavegacao.self) private var roteador
    @State private var viewModel: DetalhesViewModel
    
    init(idPokemon: Int) {
        _viewModel = State(initialValue: DetalhesViewModel(idPokemon: idPokemon))
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Detalhes do Pokémon #\(viewModel.idPokemon)")
                .font(.title)

            Button("Voltar") {
                roteador.voltar()
            }
            .buttonStyle(.borderedProminent)

            Button("Início") {
                roteador.voltarParaOInicio()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    DetalhesView(idPokemon: 25)
        .environment(RoteadorNavegacao())
}
