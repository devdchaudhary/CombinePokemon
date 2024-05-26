//
//  CardDetailView.swift
//  CombinePokemon
//
//  Created by devdchaudhary on 26/05/24.
//

import SwiftUI

struct CardDetailView: View {
    
   @Binding var card: Card?
    
    var body: some View {
        if let card {
            VStack {
                AsyncImage(url: .init(string: card.images.small)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .padding(.horizontal)
                        .frame(maxWidth: 300, maxHeight: 500)
                } placeholder: {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                
                Text(card.name)
                
                Text("HP: \(card.hp ?? "")")
                
                Text("Level: \(card.level ?? "")")
                
                Text("Rarity: \(card.rarity ?? "")")
                
            }
        }
    }
}
