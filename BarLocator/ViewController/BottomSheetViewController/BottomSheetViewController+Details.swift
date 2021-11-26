//
//  BottomSheetViewController+Details.swift
//  BarLocator
//
//  Created by Alexis Vautier on 26/11/2021.
//

import Foundation
import MapKit
import UIKit

extension BottomSheetViewController {
    func showBreweryDetail(brewery: Brewery) {
        self.brewery = brewery
        setupBreweryDetail(brewery: brewery)

        if brewery.isFavorited() {
            breweryFavoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            breweryFavoriteButton.setTitle(" Retirer des Favoris", for: .normal)
        } else {
            breweryFavoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            breweryFavoriteButton.setTitle(" Ajouter aux Favoris", for: .normal)

        }
       
        addToHistory()
    }

    func setupBreweryDetail(brewery: Brewery) {
        searchViewDetails.isHidden = true
        breweryDetails.isHidden = false

        breweryClose.setTitle("", for: .normal)
        
        breweryName.text = brewery.name
        breweryWebsite.text = brewery.website_url?.absoluteString ?? ""
        breweryPhone.text = brewery.phone
        breweryAdress.text = "\(brewery.street ?? "") \(brewery.address_2 ?? "") \(brewery.address_3 ?? "")\n\(brewery.postal_code ?? "") \(brewery.city)"

    }
}

extension BottomSheetViewController {
    @IBAction func toggleFavorites() {
        guard let brewery = brewery else { return }
        if brewery.isFavorited() {
            removeFromFavorites()
        } else {
            addToFavorites()
        }
    }
    
    @IBAction func centerOnMap() {
        guard let brewery = brewery else {
            return
        }
        mapViewControllerDelegate?.shouldReduce(animated: true)
        mapViewControllerDelegate?.shouldZoomAndLoad(brewery: brewery)
    }
    
    
    @IBAction func hideBreweryDetail() {
        self.brewery = nil
        searchViewDetails.isHidden = false
        breweryDetails.isHidden = true
    }
    
    @IBAction func goToLocation() {
        guard let brewery = brewery,
              let latitudeAsDouble = Double(brewery.latitude ?? ""),
              let longitudeAsDouble = Double(brewery.longitude ?? "") else {
            return
        }
        
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitudeAsDouble, longitude: longitudeAsDouble),
                                    addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = brewery.name
        mapItem.openInMaps(launchOptions: options)
    }
}
