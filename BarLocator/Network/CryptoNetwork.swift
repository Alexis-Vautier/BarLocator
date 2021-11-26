//
//  CryptoNetwork.swift
//  BarLocator
//
//  Created by Alexis Vautier on 26/11/2021.
//

import Alamofire
import Foundation

class CryptoNetwork {
    // https://api.coingecko.com/api/v3/global
    
    static var shared = CryptoNetwork()
    let url = "https://api.coingecko.com/api/v3/global"
    
    func global(success: @escaping (GlobalMarket) -> Void,
                failure: @escaping (AFError) -> Void) {
        guard let path = URL(string: url) else { return }
        AF.request(path).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data,
                   let market = try? JSONDecoder().decode(GlobalMarket.self, from: data) {
                    success(market)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
}
