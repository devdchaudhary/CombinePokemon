//
//  Client.swift
//  CombinePokemon
//
//  Created by devdchaudhary on 18/05/24.
//

import Foundation
import Combine

enum URLExtension: String {
    
    case cards = "v2/cards"
    
}

class Client {
    
    let baseUrl = "https://api.pokemontcg.io/"
    
    static let shared = Client()
    
    func fetchCards(pageNo: Int) -> AnyPublisher<PokemonTCGResponse, Error> {
        
        var request =  URLRequest(url: URL(string: baseUrl + URLExtension.cards.rawValue + "?page=\(pageNo)&pageSize=15")!)
        
        request.httpMethod = "GET"
                
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: PokemonTCGResponse.self, decoder: JSONDecoder())
            .mapError{ error in
                return error
            }
            .eraseToAnyPublisher()
            
    }
    
}
