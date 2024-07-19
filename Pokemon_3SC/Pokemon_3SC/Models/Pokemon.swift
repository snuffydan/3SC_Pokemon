//
//  Pokemon.swift
//  Pokemon_3SC
//
//  Created by Danushika Priyadarshani on 18/07/2024.
//

import Foundation
import SwiftUI

struct Pokemon: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let sprites: Sprites?
    let types: [PokemonType]?
    let stats: [Stat]?

    var formattedName: String { name.capitalized }
    var typeNames: [String] { (types ?? []).map { $0.type.name.capitalized } }
    var imageUrl: String { sprites?.frontDefault ?? "" }
}

struct Sprites: Codable, Hashable {
    let frontDefault: String?
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct PokemonType: Codable, Hashable {
    let slot: Int
    let type: TypeDetails
}

struct TypeDetails: Codable, Hashable {
    let name: String
    let url: String
}

struct Stat: Codable, Hashable {
    let baseStat: Int
    let effort: Int
    let stat: StatDetails
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
}

struct StatDetails: Codable, Hashable {
    let name: String
}


