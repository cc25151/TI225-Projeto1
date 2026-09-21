import SwiftUI

@Observable
final class RoteadorNavegacao {
    var caminho = [Rota]()
    
    func navegarPara(_ rota: Rota) {
        caminho.append(rota)
    }
    
    func voltar() {
        if !caminho.isEmpty {
            caminho.removeLast()
        }
    }
    
    func voltarParaOInicio() {
        caminho.removeAll()
    }
}
