import SwiftUI

struct ContentView: View {
    let categorias = ["tipo", "cor", "geração"]

    var body: some View {
        ZStack {
            Color.blue.opacity(0.15).ignoresSafeArea()
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                Spacer()
                VStack(spacing: 12) {
                    ForEach(categorias, id: \.self) { categoria in
                        Button(action: {}) {
                            Text("Buscar por \(categoria)")
                                .font(.system(size: 24))
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal, 32)
                        .tint(Color(red: 0.35, green: 0.47, blue: 0.58))
                        .controlSize(.large)
                    }
                }
                Spacer()
                VStack {
                    Text("Projeto desenvolvido por:")
                    Text("Gabriel Bellini Camargo - 25131")
                    Text("Pedro Henrique Sakamoto Mendes - 25151")
                }
                .font(.system(size: 12))
            }
        }
    }
}

#Preview {
    ContentView()
}
