import SwiftUI

struct PokemonCardView: View {
    let pokemon: PokemonModel

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(pokemon.nome)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(.primary)

                Spacer()

                Text(pokemon.numeroFormatado)
                    .font(.system(.callout, design: .monospaced, weight: .semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.06), in: Capsule())
            }

            AsyncImage(url: URL(string: pokemon.imagemURL)) { fase in
                switch fase {
                case .success(let imagem):
                    imagem
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 8)
                case .failure:
                    Image(systemName: "questionmark.ar.container")
                        .font(.largeTitle)
                        .frame(height: 180)
                case .empty:
                    Image(systemName: "questionmark.ar.container")
                        .font(.largeTitle)
                        .frame(height: 180)
                @unknown default:
                    ProgressView()
                        .frame(height: 180)
                }
            }

            HStack(spacing: 8) {
                ForEach(pokemon.tipos, id: \.self) { tipo in
                    Text(tipo)
                        .font(.caption.bold())
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(corParaTipo(tipo).opacity(0.2))
                        .foregroundStyle(corParaTipo(tipo))
                        .clipShape(Capsule())
                }
            }

            Divider()

            HStack(spacing: 16) {
                AtributoView(titulo: "HP", valor: pokemon.hp, cor: .green)
                AtributoView(titulo: "ATQ", valor: pokemon.ataque, cor: .orange)
                AtributoView(titulo: "DEF", valor: pokemon.defesa, cor: .blue)
            }
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.6), lineWidth: 1.5)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 8)
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
}

struct AtributoView: View {
    let titulo: String
    let valor: Int
    let cor: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(titulo)
                .font(.caption2.bold())
                .foregroundStyle(.secondary)

            Text("\(valor)")
                .font(.callout.bold())
                .foregroundStyle(cor)
        }
        .frame(maxWidth: .infinity)
    }
}
