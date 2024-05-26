//
//  CardsModel.swift
//  CombinePokemon
//
//  Created by devdchaudhary on 18/05/24.
//

import Foundation

// MARK: - Card Model
struct Card: Codable {
    let id: String
    let name: String
    let supertype: String
    let subtypes: [String]?
    let level: String?
    let hp: String?
    let types: [String]?
    let evolvesFrom: String?
    let abilities: [Ability]?
    let attacks: [Attack]?
    let weaknesses: [Weakness]?
    let resistances: [Resistance]?
    let retreatCost: [String]?
    let convertedRetreatCost: Int?
    let set: CardSet
    let number: String
    let artist: String?
    let rarity: String?
    let flavorText: String?
    let nationalPokedexNumbers: [Int]?
    let legalities: Legalities
    let images: CardImages
    let tcgplayer: TCGPlayer?
    let cardmarket: CardMarket?
}

// MARK: - Ability Model
struct Ability: Codable {
    let name: String
    let text: String
    let type: String
}

// MARK: - Attack Model
struct Attack: Codable {
    let cost: [String]
    let name: String
    let text: String?
    let damage: String?
    let convertedEnergyCost: Int
}

// MARK: - Weakness Model
struct Weakness: Codable {
    let type: String
    let value: String
}

// MARK: - Resistance Model
struct Resistance: Codable {
    let type: String
    let value: String
}

// MARK: - CardSet Model
struct CardSet: Codable {
    let id: String
    let name: String
    let series: String
    let printedTotal: Int?
    let total: Int
    let legalities: Legalities
    let ptcgoCode: String?
    let releaseDate: String
    let updatedAt: String
    let images: SetImages
}

// MARK: - Legalities Model
struct Legalities: Codable {
    let unlimited: String?
    let standard: String?
    let expanded: String?
}

// MARK: - CardImages Model
struct CardImages: Codable {
    let small: String
    let large: String
}

// MARK: - SetImages Model
struct SetImages: Codable {
    let symbol: String
    let logo: String
}

// MARK: - TCGPlayer Model
struct TCGPlayer: Codable {
    let url: String
    let updatedAt: String
    let prices: [String: Price]?
}

// MARK: - CardMarket Model
struct CardMarket: Codable {
    let url: String
    let updatedAt: String
    let prices: MarketPrices?
}

// MARK: - Price Model
struct Price: Codable {
    let low: Double?
    let mid: Double?
    let high: Double?
    let market: Double?
    let directLow: Double?
}

// MARK: - MarketPrices Model
struct MarketPrices: Codable {
    let averageSellPrice: Double?
    let lowPrice: Double?
    let trendPrice: Double?
    let germanProLow: Double?
    let suggestedPrice: Double?
}

// MARK: - PokemonTCGResponse Model
struct PokemonTCGResponse: Codable {
    var data: [Card]
    let page: Int
    let pageSize: Int
    let count: Int
    let totalCount: Int
}
