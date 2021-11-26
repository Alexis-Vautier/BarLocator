//
//  MapViewController+LocationManager.swift
//  BarLocator
//
//  Created by Alexis Vautier on 26/11/2021.
//

import CoreLocation
import Foundation
import MapKit

extension MapViewController: CLLocationManagerDelegate {
    func setupLocation() {

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            // HANDLE ERROR
        } else if let location = locationManager.location {
            if let locationDistance = CLLocationDistance(exactly: 1000) {
                let region = MKCoordinateRegion( center: location.coordinate,
                                                 latitudinalMeters: locationDistance,
                                                 longitudinalMeters: locationDistance)
                mapView.setRegion(mapView.regionThatFits(region), animated: true)
            }

            getClosestBreweriesFrom(latitude: location.coordinate.latitude,
                                    longitude: location.coordinate.longitude)
        } else if CLLocationManager.authorizationStatus() == .denied {
            getClosestBreweriesFrom(latitude: mapView.centerCoordinate.latitude,
                                    longitude: mapView.centerCoordinate.longitude)
        }
        
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager.startUpdatingLocation()
        
        if let location = locationManager.location {
            if let locationDistance = CLLocationDistance(exactly: 1000) {
                let region = MKCoordinateRegion( center: location.coordinate,
                                                 latitudinalMeters: locationDistance,
                                                 longitudinalMeters: locationDistance)
                mapView.setRegion(mapView.regionThatFits(region), animated: true)
            }

            getClosestBreweriesFrom(latitude: location.coordinate.latitude,
                                    longitude: location.coordinate.longitude)
        }
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        if let location = manager .location {
            if let locationDistance = CLLocationDistance(exactly: 1000) {
                let region = MKCoordinateRegion( center: location.coordinate,
                                                 latitudinalMeters: locationDistance,
                                                 longitudinalMeters: locationDistance)
                mapView.setRegion(mapView.regionThatFits(region), animated: true)
            }

            getClosestBreweriesFrom(latitude: location.coordinate.latitude,
                                    longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
    }
    
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /*guard let coordinate = locations.first?.coordinate else { return }
        
        getClosestBreweriesFrom(latitude: "\(coordinate.latitude)", longitude: "\(coordinate.longitude)")*/
    }
}
