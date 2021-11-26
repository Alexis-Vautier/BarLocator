//
//  MapViewController+MapViewControllerDelegate.swift
//  BarLocator
//
//  Created by Alexis Vautier on 26/11/2021.
//

import CoreLocation
import Foundation

protocol MapViewControllerDelegate: AnyObject {
    func shouldExpand(animated: Bool)
    func shouldReduce(animated: Bool)
    
    func shouldZoomAndLoad(brewery: Brewery)
    func getClosedBreweries() -> [Brewery]
}

extension MapViewController: MapViewControllerDelegate {
    func shouldZoomAndLoad(brewery: Brewery) {
        
        guard let latitude = Double(brewery.latitude ?? ""),
              let longitude = Double(brewery.longitude ?? "") else { return }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        centerTo(coordinate: coordinate)
                
        
        getClosestBreweriesFrom(latitude: coordinate.latitude,
                                longitude: coordinate.longitude)
    }
    
    func shouldReduce(animated: Bool) {
        sheetCoordinator?.setToNearest(sheetCoordinator.availableHeight, animated: animated)
    }
    
    func shouldExpand(animated: Bool) {
        sheetCoordinator?.setToNearest(0.1, animated: animated)
        
    }
    
    func getClosedBreweries() -> [Brewery] {
        return annotations.map { $0.0 }
    }
}
