import SwiftUI

struct InicioView: View {
    @Environment(RoteadorNavegacao.self) private var roteador
    @State private var viewModel = InicioViewModel()

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.85, green: 0.92, blue: 0.98),
                    Color(red: 0.95, green: 0.97, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 260)
                    .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)

                Spacer()

                VStack(spacing: 14)
                {
                    ForEach(viewModel.categorias, id: \.self)
                    { categoria in
                        Button(action: {
                                roteador.navegarPara(.galeria(categoria: categoria))
                            }) {
                                HStack(spacing: 16) {
                                    Image(systemName: iconeParaCategoria(categoria))
                                        .font(.title3)

                                    Text("Buscar por \(categoria)")
                                        .font(.system(.body, design: .rounded, weight: .bold))

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(.footnote.bold())
                                        .opacity(0.6)
                                }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .foregroundStyle(.white)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.28, green: 0.42, blue: 0.55),
                                        Color(red: 0.20, green: 0.32, blue: 0.45)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(EfeitoCliqueButtonStyle())
                    }
                }
                .padding(.horizontal, 28)

                Spacer()

                VStack(spacing: 6) {
                    Text("PROJETO DESENVOLVIDO POR")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundStyle(.secondary)
                        .tracking(1)

                    VStack(spacing: 2) {
                        Text("Gabriel Bellini Camargo • 25131")
                        Text("Pedro Henrique Sakamoto Mendes • 25151")
                    }
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.primary)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                .padding(.bottom, 8)
            }
        }
    }

    private func iconeParaCategoria(_ categoria: String) -> String {
        let cat = categoria.lowercased()
        if cat.contains("tipo") { return "tag.fill" }
        if cat.contains("cor") { return "paintpalette.fill" }
        if cat.contains("gera") || cat.contains("geração") { return "sparkles" }
        return "magnifyingglass"
    }
}

struct EfeitoCliqueButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    InicioView()
        .environment(RoteadorNavegacao())
}
