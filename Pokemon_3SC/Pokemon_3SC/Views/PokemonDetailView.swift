//
//  PokemonDetailView.swift
//  Pokemon_3SC
//
//  Created by Danushika Priyadarshani on 19/07/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct PokemonDetailView: View {
    let pokemon: Pokemon
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                if let url = URL(string: pokemon.imageUrl) {
                    WebImage(url: url)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .accessibilityLabel(pokemon.formattedName)
                }
                
                Text(pokemon.formattedName)
                    .font(.title)
                    .accessibilityAddTraits(.isHeader)

                TypeListView(types: pokemon.types ?? [])

                StatsView(stats: pokemon.stats)
            }
            .padding()
            .navigationTitle(pokemon.formattedName)
            .navigationBarTitleDisplayMode(.inline)
            .accessibilityAction(.magicTap) {
                let announcement = "This page has scrollable content of \(pokemon.formattedName) Pokemon."
                UIAccessibility.post(notification: .announcement, argument: announcement)
            }
        }
    }
}

struct TypeListView: View {
    let types: [PokemonType]

    var body: some View {
        HStack {
            ForEach(types, id: \.slot) { type in
                Text(type.type.name.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.3))
                    )
            }
        }
    }
}


struct StatsView: View {
    let stats: [Stat]?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Base Stats")
                .font(.headline)
            ForEach(stats ?? [], id: \.stat.name) { stat in
                HStack {
                    Text(stat.stat.name.capitalized)
                    Spacer()
                    Text("\(stat.baseStat)")
                }
            }
        }
    }
}
