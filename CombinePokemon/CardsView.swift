//
//  ContentView.swift
//  CombinePokemon
//
//  Created by devdchaudhary on 17/05/24.
//

import SwiftUI

struct CardsView: View {
    
    @StateObject private var vm = CardsViewModel()
    
    @State private var selectedCard: Card? = nil
    
    @State private var showDetail = false
    @State private var pageNo = 1
    
    let items: [GridItem] = [
        .init(.flexible(), spacing: 0),
        .init(.flexible(), spacing: 0),
        .init(.flexible(), spacing: 0)
    ]
    
    var body: some View {
        
        VStack {
            
            Text("Pokemon: Gotta Catch em all!")
                .font(.system(size: 18))
            
            ScrollView(.vertical, showsIndicators: false) {
                
                LazyVGrid(columns: items, spacing: 0) {
                    
                    ForEach(vm.cards?.data ?? [], id: \.id) { card in
                        Button {
                            showDetailClicked(card)
                        } label: {
                            AsyncImage(url: .init(string: card.images.small)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                                    .progressViewStyle(.circular)
                            }
                            .padding()
                        }
                        .frame(maxWidth: .infinity, maxHeight: 500)
                        .sheet(isPresented: $showDetail) {
                            CardDetailView(card: $selectedCard)
                        }
                    }
                    
                    Color.clear
                        .frame(height: 80)
                        .onAppear {
                            pageNo += 1
                            vm.fetchPokemonCards(pageNo: pageNo, true)
                        }
                    
                }
                .padding(.top)
            }
        }
        .alert(isPresented: $vm.showingAlert, content: {
            Alert(title: Text(vm.alertTitle),
                  message: Text(vm.alertMessage),
                  dismissButton: .default(Text("OK")))
        })
        .onAppear {
            vm.fetchPokemonCards(pageNo: pageNo, false)
        }
        .refreshable {
            vm.cards = nil
            vm.fetchPokemonCards(pageNo: pageNo, false)
        }
    }
    
    private func showDetailClicked(_ card: Card) {
        selectedCard = card
        showDetail.toggle()
    }
    
}

#Preview {
    CardsView()
}
