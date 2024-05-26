# CombinePokemon

CombinePokemon is a small iOS application built using the Combine framework and MVVM architecture. It fetches and displays Pokémon cards from the Pokémon TCG API. The app supports pagination and adheres to the principles of Combine and functional reactive programming.

![Simulator Screenshot - iPhone 14 Pro - 2024-05-26 at 14 22 34](https://github.com/devdchaudhary/VoiceRecorderKit/assets/52855516/048cb1e4-b17b-4e85-8c4f-32fa1e832875)

## Features

- Fetch Pokémon cards from the Pokémon TCG API.
- Display Pokémon cards in a scrollable list.
- Support for pagination to load more cards.
- Fully compliant with Combine and functional reactive programming principles.
- Built with the MVVM (Model-View-ViewModel) architecture for a clean and maintainable codebase.

## Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.3+

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/devdchaudhary/CombinePokemon.git
   ```
2. Open the project in Xcode:
   ```bash
   cd CombinePokemon
   open CombinePokemon.xcodeproj
   ```
3. Build and run the project on your chosen simulator or device.

## Usage

Upon launching the app, it will fetch and display the first 12 Pokémon cards. As you scroll down, more cards will be loaded automatically, thanks to the pagination support.

## Architecture

### MVVM (Model-View-ViewModel)

- **Model:** Defines the data structure for Pokémon cards.
- **ViewModel:** Manages the data for the views by processing and exposing data streams.
- **View:** Displays the data and binds to the ViewModel using Combine publishers and subscribers.

### Combine

Combine framework is used for handling asynchronous events and data streams. The app leverages Combine for network requests, data binding, and state management.

## Code Overview

### Models

`Card`: Represents a single Pokémon card.

```swift
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
```

### ViewModels

`PokemonCardsViewModel`: Manages fetching and storing the Pokémon cards, as well as handling pagination.

```swift
class CardsViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var cards: PokemonTCGResponse?
    
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    @Published var showingAlert = false
    
    func fetchPokemonCards(pageNo: Int,_ isPaginating: Bool) {
        Client.shared.fetchCards(pageNo: pageNo)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                if let self {
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
                }
            }, receiveValue: { [weak self] cards in
                if let self {
                    if isPaginating {
                        self.cards?.data += cards.data
                    } else {
                        self.cards = cards
                    }
                }
            })
            .store(in: &cancellables)
    }
    
}
```

### Views

`ContentView`: Displays the list of Pokémon cards and handles pagination.

```swift
struct CardsView: View {
    
    @StateObject private var vm = CardsViewModel()
    
    @State private var showingAlert = false
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
                        AsyncImage(url: .init(string: card.images.small)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 500)
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
}
```

### Supporting Files

`Client`: A helper to fetch the request using ```URLSession.shared.dataTaskPublisher```

```swift
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
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## License

CombinePokemon is released under the MIT License. See [LICENSE](LICENSE) for details.

---

Enjoy using CombinePokemon! If you have any questions or feedback, feel free to reach out.

