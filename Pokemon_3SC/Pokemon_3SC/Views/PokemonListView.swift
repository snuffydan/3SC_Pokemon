//
//  PokemonListView.swift
//  Pokemon_3SC
//
//  Created by Danushika Priyadarshani on 18/07/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct PokemonListView: View {
    @ObservedObject var viewModel = PokemonListViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(viewModel.pokemon) { pokemon in
                        NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                            PokemonRow(pokemon: pokemon)
                        }
                        .onAppear {
                            if viewModel.shouldLoadMore(pokemon) {
                                viewModel.loadMore()
                            }
                        }
                    }
                    if viewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                }
                .listStyle(.plain)
                .refreshable { viewModel.fetchPokemonList() }
                .navigationTitle("Pokémon List")
                
                if let error = viewModel.error {
                    ErrorView(error: error, retryAction: {
                        viewModel.fetchPokemonList()
                    })
                }
            }
        }
    }
}

struct PokemonRow: View {
    let pokemon: Pokemon
    var body: some View {
        HStack {
            if let url = URL(string: pokemon.sprites?.frontDefault ?? "") {
                WebImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Rectangle().foregroundColor(.gray)
                }
                .onSuccess { image, data, cacheType in }
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
            } else {
                ProgressView()
                    .frame(width: 100, height: 100)
            }
            Text(pokemon.formattedName)
        }
    }
}

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Error: \(error.localizedDescription)")
            Button("Retry", action: retryAction)
        }
    }
}

