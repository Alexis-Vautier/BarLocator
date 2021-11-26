//
//  MapViewController+Actions.swift
//  BarLocator
//
//  Created by Alexis Vautier on 26/11/2021.
//

import Foundation

extension MapViewController {
    @IBAction func reloadBreweries() {
        getClosestBreweriesFrom(latitude: mapView.centerCoordinate.latitude,
                                longitude: mapView.centerCoordinate.longitude)

    }
    
    @IBAction func centerLocation() {
        if let location = locationManager.location {
            centerTo(coordinate: location.coordinate)
        }
    }
}
