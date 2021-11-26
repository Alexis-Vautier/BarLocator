//
//  MapViewController+MapView.swift
//  BarLocator
//
//  Created by Alexis Vautier on 26/11/2021.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
    func setupMapview() {
        mapView.delegate = self
        self.mapView.register(BreweryAnnotationView.self,
                              forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = (view.annotation as? MKPointAnnotation),
        let index = annotations.map({ $1 }).firstIndex(of: annotation), index < annotations.count else { return }
        
        let brewery = annotations[index].0
        bottomSheetViewController.showBreweryDetail(brewery: brewery)
    }

    func addAnnotations(breweries: [Brewery]) {
        annotations.removeAll()
        var tempAnnotations = [(Brewery, MKPointAnnotation)]()
        for brewery in breweries {
            if let annotation = brewery.convertToMKAnnotation() {
                tempAnnotations.append((brewery,annotation))
            }
        }
        
        annotations.append(contentsOf: tempAnnotations)
        mapView.addAnnotations(annotations.map { $1 })
    }
    
    func centerTo(coordinate: CLLocationCoordinate2D) {
        if let locationDistance = CLLocationDistance(exactly: 1000) {
            let region = MKCoordinateRegion( center: coordinate,
                                             latitudinalMeters: locationDistance,
                                             longitudinalMeters: locationDistance)
            mapView.setRegion(mapView.regionThatFits(region), animated: true)
        }
        
    }
}
