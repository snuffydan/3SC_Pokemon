//
//  PokemonListResponse.swift
//  Pokemon_3SC
//
//  Created by Danushika Priyadarshani on 18/07/2024.
//

import Foundation

struct PokemonListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonListItem]
}

struct PokemonListItem: Codable, Identifiable {
    let name: String
    let url: String

    var id: Int {
        URLComponents(string: url)?.path.components(separatedBy: "/").dropLast().last.flatMap { Int($0) } ?? 0
    }
}

