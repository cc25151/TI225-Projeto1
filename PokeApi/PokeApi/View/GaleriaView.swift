import SwiftUI

struct GaleriaView: View {
    @Environment(RoteadorNavegacao.self) private var roteador
    @State private var viewModel = GaleriaViewModel()
    
    var body: some View {
        VStack {
            Text("Galeria")
            Button(action: { roteador.navegarPara(.detalhes(idPokemon: 10)) }) {
                Text("Detalhes")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    GaleriaView()
        .environment(RoteadorNavegacao())
}
