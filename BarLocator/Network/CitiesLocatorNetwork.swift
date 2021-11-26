//
//  CitiesLocatorNetwork.swift
//  BarLocator
//
//  Created by Alexis Vautier on 26/11/2021.
//

import Alamofire
import Foundation

class CitiesLocatorNetwork {
    static var shared = CitiesLocatorNetwork()
    let url = "https://api.teleport.org/api/cities/?"
    
    func search(query: String,
                success: @escaping ([City]) -> Void,
                failure: @escaping (AFError) -> Void) {
        let fullUrl = url + CitiesLocatorAPI.search(query: query).getURLPath()
        guard let path = URL(string: fullUrl) else { return }
        AF.request(path).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data,
                   let cities = try? JSONDecoder().decode(CitiesEmbedded.self, from: data) {
                    success(cities.citiesEmbbded.cities)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
}

enum CitiesLocatorAPI {
    case search(query: String)
    
    func getURLPath() -> String {
        switch self {
        case .search(let query): return "search=\(query)"
        }
    }
}
