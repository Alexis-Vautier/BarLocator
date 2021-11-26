//
//  City.swift
//  BarLocator
//
//  Created by Alexis Vautier on 26/11/2021.
//

import Foundation

struct CitiesEmbedded: Decodable {
    let citiesEmbbded: Cities
    
    private enum CodingKeys: String, CodingKey {
        case citiesEmbbded = "_embedded"
    }
}

struct Cities: Decodable {
    let cities: [City]
    
    private enum CodingKeys: String, CodingKey {
        case cities = "city:search-results"
    }
}

struct City: Decodable {
    let fullname: String
    
    private enum CodingKeys: String, CodingKey {
        case fullname = "matching_full_name"
    }
}
