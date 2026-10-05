import SwiftUI

struct DetalhesView: View {
    let pokemon: PokemonModel

    @Environment(RoteadorNavegacao.self) private var roteador
    @State private var viewModel = DetalhesViewModel()

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

            VStack(spacing: 0) {
                cabecalhoView
                    .padding(.horizontal, 20)
                    .padding(.top, 12)

                if viewModel.carregando {
                    Spacer()
                    ProgressView("Carregando informações...")
                        .controlSize(.large)
                        .tint(Color(red: 0.28, green: 0.42, blue: 0.55))
                    Spacer()
                } else if let erro = viewModel.mensagemErro {
                    Spacer()
                    ContentUnavailableView(
                        "Erro",
                        systemImage: "exclamationmark.triangle",
                        description: Text(erro)
                    )
                    Spacer()
                } else if let detalhado = viewModel.pokemonDetalhado {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            AsyncImage(url: URL(string: detalhado.imagemURL)) { fase in
                                switch fase {
                                case .success(let imagem):
                                    imagem
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 220)
                                        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 8)
                                case .failure:
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .frame(height: 220)
                                case .empty:
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .frame(height: 220)
                                @unknown default:
                                    ProgressView()
                                        .frame(height: 220)
                                }
                            }
                            .padding(.top, 10)

                            HStack(spacing: 10) {
                                ForEach(detalhado.tipos, id: \.self) { tipo in
                                    Text(tipo)
                                        .font(.subheadline.bold())
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(corParaTipo(tipo).opacity(0.2))
                                        .foregroundStyle(corParaTipo(tipo))
                                        .clipShape(Capsule())
                                }
                            }

                            HStack(spacing: 16) {
                                VStack(spacing: 4) {
                                    Text("ALTURA")
                                        .font(.caption2.bold())
                                        .foregroundStyle(.secondary)
                                    Text("\(detalhado.altura, specifier: "%.1f") m")
                                        .font(.title3.bold())
                                        .foregroundStyle(Color(red: 0.20, green: 0.32, blue: 0.45))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))

                                VStack(spacing: 4) {
                                    Text("PESO")
                                        .font(.caption2.bold())
                                        .foregroundStyle(.secondary)
                                    Text("\(detalhado.peso, specifier: "%.1f") kg")
                                        .font(.title3.bold())
                                        .foregroundStyle(Color(red: 0.20, green: 0.32, blue: 0.45))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                            }

                            VStack(alignment: .leading, spacing: 12) {
                                Text("HABILIDADES")
                                    .font(.caption.bold())
                                    .foregroundStyle(.secondary)
                                    .tracking(1)

                                HStack(spacing: 8) {
                                    ForEach(detalhado.habilidades, id: \.self) { habilidade in
                                        Text(habilidade)
                                            .font(.footnote.weight(.semibold))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.black.opacity(0.05), in: Capsule())
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))

                            VStack(alignment: .leading, spacing: 14) {
                                Text("ESTATÍSTICAS BASE")
                                    .font(.caption.bold())
                                    .foregroundStyle(.secondary)
                                    .tracking(1)

                                ForEach(detalhado.estatisticas, id: \.self) { item in
                                    cardEstatisticaView(item: item)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.carregarDetalhes(pokemon: pokemon)
        }
    }

    private var cabecalhoView: some View {
        HStack {
            Button(action: {
                roteador.voltar()
            }) {
                Image(systemName: "chevron.left")
                    .font(.title3.bold())
                    .foregroundStyle(Color(red: 0.20, green: 0.32, blue: 0.45))
                    .padding(12)
                    .background(.ultraThinMaterial, in: Circle())
            }

            Spacer()

            VStack(spacing: 2) {
                Text(pokemon.numeroFormatado)
                    .font(.caption2.bold())
                    .foregroundStyle(.secondary)
                    .tracking(1.2)

                Text(pokemon.nome)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Color(red: 0.20, green: 0.32, blue: 0.45))
            }

            Spacer()

            Color.clear
                .frame(width: 44, height: 44)
        }
    }

    private func cardEstatisticaView(item: EstatisticaModel) -> some View {
        VStack(spacing: 6) {
            HStack {
                Text(item.nome)
                    .font(.subheadline.weight(.medium))
                Spacer()
                Text("\(item.valor)")
                    .font(.subheadline.bold())
            }

            ProgressView(value: Float(item.valor), total: 255)
                .tint(corParaAtributo(item.valor))
        }
    }

    private func corParaTipo(_ tipo: String) -> Color {
        switch tipo.lowercased() {
        case "grass", "grama": return .green
        case "fire", "fogo": return .red
        case "water", "água", "agua": return .blue
        case "electric", "elétrico", "eletrico": return .yellow
        case "poison", "venenoso": return .purple
        case "psychic", "psíquico": return .pink
        default: return Color(red: 0.35, green: 0.47, blue: 0.58)
        }
    }

    private func corParaAtributo(_ valor: Int) -> Color {
        if valor < 50 { return .red }
        if valor < 90 { return .orange }
        return .green
    }
}
