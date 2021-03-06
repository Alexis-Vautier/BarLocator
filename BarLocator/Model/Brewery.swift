//
//  Brewery.swift
//  BarLocator
//
//  Created by Alexis Vautier on 26/11/2021.
//

import Foundation
import MapKit

struct Brewery: Decodable, Encodable {
    let id: String
    let name: String
    let brewery_type: String
    let street: String?
    let address_2: String?
    let address_3: String?
    let city: String
    let state: String?
    let county_province: String?
    let postal_code: String?
    let country: String
    var longitude: String?
    var latitude: String?
    let phone: String?
    let website_url: URL?
    let updated_at: String? //"2018-08-23T23:24:11.758Z",
    let created_at: String //"2018-08-23T23:24:11.758Z"
    
    func convertToMKAnnotation() -> MKPointAnnotation? {
        guard let latitudeAsLocation = Double(latitude ?? ""),
              let longitudeAsLocation = Double(longitude ?? "") else { return nil }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitudeAsLocation,
                                                        longitude: longitudeAsLocation)
        //annotation.title = name
        
        return annotation
    }
    
    func getFormattedDistanceFrom(location: CLLocation?) -> String? {
        if let location = location,
            let latitude = Double(self.latitude ?? ""),
           let longitude = Double(self.longitude ?? "") {
            let distance = Int(location.distance(from: CLLocation(latitude: latitude, longitude: longitude)))
            
            if distance < 1000 {
                return "\(distance)m"
            } else {
                return "\(distance / 1000)km"
            }
        } else {
            return nil
        }
    }
    
    func isFavorited() -> Bool {
        if let data = UserDefaults.standard.value(forKey: "favorites") as? Data,
           let favoritesBreweries = try? PropertyListDecoder().decode(Array<Brewery>.self, from: data) {
            if favoritesBreweries.contains(where: { breweryInArray in
                self.id == breweryInArray.id
            }) {
                return true
            } else {
                return false
            }
        } else { return false }
    }
}
