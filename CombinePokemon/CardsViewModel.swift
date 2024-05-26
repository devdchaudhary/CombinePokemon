//
//  CardsViewModel.swift
//  CombinePokemon
//
//  Created by devdchaudhary on 18/05/24.
//

import SwiftUI
import Combine

class CardsViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var cards: PokemonTCGResponse? = nil
    
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    @Published var showingAlert = false
    
    func fetchPokemonCards(pageNo: Int,_ isPaginating: Bool) {
        Client.shared.fetchCards(pageNo: pageNo)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    if isPaginating { return } else {
                        self.alertTitle = "Success!"
                        self.alertMessage = "Gotta fetch em all!"
                        self.showingAlert = true
                    }
                case .failure(let error):
                    self.alertTitle = "Error!"
                    self.alertMessage =  error.localizedDescription
                    self.showingAlert = true
                }
            }, receiveValue: { cards in
                if isPaginating {
                    self.cards?.data += cards.data
                } else {
                    self.cards = cards
                }
            })
            .store(in: &cancellables)
    }
    
}
