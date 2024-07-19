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
                                .accessibilityElement(children: .combine)
                        }
                        .accessibilityLabel("\(pokemon.formattedName), \(pokemon.typeNames.joined(separator: ", "))  Pokémon type")

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
                .navigationBarTitleDisplayMode(.inline)
                .accessibilityAction(.magicTap) {
                    let announcement = "This is a list of Pokemon. There are \(viewModel.pokemon.count) Pokemon."
                    UIAccessibility.post(notification: .announcement, argument: announcement)
                }
                
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
                .accessibilityLabel(pokemon.formattedName)
            } else {
                ProgressView()
                    .frame(width: 100, height: 100)
                    .accessibilityHidden(true)
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

