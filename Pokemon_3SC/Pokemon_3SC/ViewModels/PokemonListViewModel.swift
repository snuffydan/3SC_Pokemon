//
//  PokemonListViewModel.swift
//  Pokemon_3SC
//
//  Created by Danushika Priyadarshani on 18/07/2024.
//

import SwiftUI
import Combine
import Alamofire
import SDWebImageSwiftUI

class PokemonListViewModel: ObservableObject {
    @Published var pokemon: [Pokemon] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private var nextPageUrl: String?
    private let pageSize = 20
    @Published private var totalPokemonCount: Int = 0
    private var isFirstPage = true
    
    init() {
        fetchPokemonList()
    }
    
    /// Fetches a list of Pokemon from the base URL.
    public func fetchPokemonList(from urlString: String? = nil) {
        isLoading = true
        error = nil
        let urlString = urlString ?? API_URL
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: PokemonListResponse.self) { [weak self] response in
                guard let self = self else { return }
                
                self.isLoading = false
                
                switch response.result {
                case .success(let listResponse):
                    let newPokemon = listResponse.results.map {
                        Pokemon(id: $0.id, name: $0.name, sprites: nil, types: nil, stats: nil)
                    }
                    if self.isFirstPage {
                        self.pokemon = newPokemon
                        self.totalPokemonCount = listResponse.count
                        self.isFirstPage = false
                    } else {
                        self.pokemon.append(contentsOf: newPokemon)
                    }
                    self.fetchPokemonDetails(for: listResponse.results)
                    self.nextPageUrl = listResponse.next
                case .failure(let error):
                    self.error = error
                    print("Error fetching Pokemon list: \(error.localizedDescription)")
                }
            }
    }
    
    /// Fetches detailed information for each Pokemon in the provided list.
    /// - Parameter pokemonList: An array of PokemonListItem objects.
    func fetchPokemonDetails(for pokemonList: [PokemonListItem]) {
        for pokemon in pokemonList {
            AF.request(pokemon.url)
                .validate()
                .responseDecodable(of: Pokemon.self) { [weak self] response in
                    guard let self = self else { return }
                    switch response.result {
                    case .success(let detailedPokemon):
                        if let index = self.pokemon.firstIndex(where: { $0.id == detailedPokemon.id }) {
                            self.pokemon[index] = detailedPokemon
                        }
                    case .failure(let error):
                        self.error = error
                        print("Error fetching details for \(pokemon.name): \(error.localizedDescription)")
                    }
                }
        }
    }
    
    /// Determines if more Pokemon should be loaded when a given Pokemon is displayed.
    /// - Parameter pokemon: The Pokemon currently being displayed.
    /// - Returns: True if more Pokemon should be loaded, false otherwise.
    func shouldLoadMore(_ pokemon: Pokemon) -> Bool {
        return self.pokemon.last?.id == pokemon.id && !isLoading && self.pokemon.count < self.totalPokemonCount
    }
    
    /// Loads the next page of Pokemon from the API.
    func loadMore() {
        guard let nextPageUrl = nextPageUrl, !isLoading else { return }
        isLoading = true
        fetchPokemonList(from: nextPageUrl)
    }
}



