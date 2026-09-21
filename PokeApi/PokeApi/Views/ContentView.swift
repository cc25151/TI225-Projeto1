//
//  ContentView.swift
//  PokeApi
//
//  Created by PEDRO HENRIQUE SAKAMOTO MENDES on 21/09/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Color.blue.opacity(0.15).ignoresSafeArea()
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                Spacer()
                VStack{
                    Button(action:{}){
                        Text("Buscar por tipo")
                            .font(.system(size: 24))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 10)
                    .tint(Color.cyan.opacity(0.7))
                    .controlSize(.large)
                    Button(action:{}){
                        Text("Buscar por cor")
                            .font(.system(size: 24))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 10)
                    .tint(Color.blue.opacity(0.7))
                    .controlSize(.large)
                    Button(action:{}){
                        Text("Buscar por tipo")
                            .font(.system(size: 24))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 10)
                    .tint(Color.blue.opacity(0.7))
                    .controlSize(.large)
                }
                Spacer()
                Text("Projeto desenvolvido por:")
                    .font(.system(size: 12))
                Text("Gabriel Bellini Camargo - 25131")
                    .font(.system(size: 12))
                Text("Pedro Henrique Sakamoto Mendes - 25151")
                    .font(.system(size: 12))
                
            }

            }
        
        }
        
}

#Preview {
    ContentView()
}
