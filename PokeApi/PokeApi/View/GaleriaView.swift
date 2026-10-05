import SwiftUI

struct GaleriaView: View {
    let categoria: String

    @Environment(RoteadorNavegacao.self) private var roteador
    @State private var viewModel = GaleriaViewModel()

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

            VStack(spacing: 16) {
                cabecalhoView
                    .padding(.horizontal, 20)
                    .padding(.top, 12)

                if !viewModel.opcoesDisponiveis.isEmpty {
                    Picker("Opção", selection: $viewModel.opcaoSelecionada) {
                        ForEach(viewModel.opcoesDisponiveis, id: \.self) { opcao in
                            Text(formatarNomeOpcao(opcao))
                                .tag(opcao)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(Color(red: 0.20, green: 0.32, blue: 0.45))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial, in: Capsule())
                    .overlay(
                        Capsule().stroke(Color.white.opacity(0.6), lineWidth: 1)
                    )
                    .onChange(of: viewModel.opcaoSelecionada) { _, _ in
                        Task {
                            await viewModel.carregarPokemons(categoria: categoria)
                        }
                    }
                }

                if viewModel.carregando {
                    Spacer()
                    VStack(spacing: 12) {
                        ProgressView()
                            .controlSize(.large)
                            .tint(Color(red: 0.28, green: 0.42, blue: 0.55))
                        Text("Carregando Pokémon...")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                } else if let erro = viewModel.mensagemErro {
                    Spacer()
                    ContentUnavailableView(
                        "Erro ao carregar",
                        systemImage: "wifi.exclamationmark",
                        description: Text(erro)
                    )
                    Spacer()
                } else if viewModel.pokemons.isEmpty {
                    Spacer()
                    ContentUnavailableView(
                        "Nenhum Pokémon encontrado",
                        systemImage: "magnifyingglass",
                        description: Text("Nenhum resultado para \(viewModel.opcaoSelecionada).")
                    )
                    Spacer()
                } else {
                    Spacer()

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(viewModel.pokemons) { pokemon in
                                Button(action: {
                                    roteador.navegarPara(.detalhes(pokemon: pokemon))
                                }) {
                                    PokemonCardView(pokemon: pokemon)
                                        .frame(width: 300, height: 470)
                                }
                                .buttonStyle(.plain)
                                .scrollTransition { conteudo, fase in
                                    conteudo
                                        .scaleEffect(fase.isIdentity ? 1.0 : 0.88)
                                        .opacity(fase.isIdentity ? 1.0 : 0.6)
                                        .rotation3DEffect(
                                            .degrees(fase.value * -12),
                                            axis: (x: 0, y: 1, z: 0)
                                        )
                                }
                            }
                        }
                        .scrollTargetLayout()
                        .padding(.horizontal, 40)
                    }
                    .scrollTargetBehavior(.viewAligned)

                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            viewModel.inicializarOpcoes(para: categoria)
            await viewModel.carregarPokemons(categoria: categoria)
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
                Text("CATEGORIA")
                    .font(.caption2.bold())
                    .foregroundStyle(.secondary)
                    .tracking(1.2)

                Text(categoria)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Color(red: 0.20, green: 0.32, blue: 0.45))
            }

            Spacer()

            Color.clear
                .frame(width: 44, height: 44)
        }
    }

    private func formatarNomeOpcao(_ opcao: String) -> String {
        switch opcao {
        case "fire": return "🔥 Fogo"
        case "water": return "💧 Água"
        case "grass": return "🌿 Grama"
        case "electric": return "⚡ Elétrico"
        case "psychic": return "🔮 Psíquico"
        case "dragon": return "🐲 Dragão"
        case "ghost": return "👻 Fantasma"
        case "red": return "🔴 Vermelho"
        case "blue": return "🔵 Azul"
        case "green": return "🟢 Verde"
        case "yellow": return "🟡 Amarelo"
        case "black": return "⚫ Preto"
        case "white": return "⚪ Branco"
        case "purple": return "🟣 Roxo"
        case "1": return "1ª Geração"
        case "2": return "2ª Geração"
        case "3": return "3ª Geração"
        case "4": return "4ª Geração"
        case "5": return "5ª Geração"
        default: return opcao.capitalized
        }
    }
}
