//
//  BreweryNetwork.swift
//  BarLocator
//
//  Created by Alexis Vautier on 26/11/2021.
//

import Alamofire
import Foundation

class BreweryNetwork {
    static var shared = BreweryNetwork()

    let url = "https://api.openbrewerydb.org/breweries?"
    func getClosestBreweriesFrom(latitude: String,
                                 longitude: String,
                                 success: @escaping ([Brewery]) -> Void,
                                 failure: @escaping (AFError?) -> Void) {
        let fullUrl = url + BreweryAPI.searchByDistance(latitude: latitude, longitude: longitude).getURLPath()
        guard let path = URL(string: fullUrl) else { return }
        
        AF.cancelAllRequests()

        AF.request(path).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data,
                   let breweries = try? JSONDecoder().decode([Brewery].self, from: data) {
                    success(breweries)
                } else {
                    failure(nil)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func getClosestBreweriesUsing(name: String,
                                 success: @escaping ([Brewery]) -> Void,
                                 failure: @escaping (AFError?) -> Void) {
        AF.cancelAllRequests()

        let fullUrl = url + BreweryAPI.searchByName(name: name).getURLPath()
        guard let path = URL(string: fullUrl) else { return }
        AF.request(path).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data,
                   let breweries = try? JSONDecoder().decode([Brewery].self, from: data) {
                    success(breweries)
                } else {
                    failure(nil)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
}

enum BreweryAPI {
    case searchByDistance(latitude: String, longitude: String)
    case searchByName(name: String)
    case searchByCity(city: String)

    func getURLPath() -> String {
        switch self {
        case .searchByDistance(let latitude, let longitude): return "by_dist=\(latitude),\(longitude)"
        case .searchByName(let name): return "by_name=\(name)"
        case .searchByCity(let city): return "by_city=\(city)"
        }
    }
}
