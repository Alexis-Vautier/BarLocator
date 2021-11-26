//
//  MapViewController.swift
//  BarLocator
//
//  Created by Alexis Vautier on 24/11/2021.
//

import UIKit
import Alamofire
import CoreLocation
import MapKit
import UBottomSheet

class MapViewController: UIViewController {
    var sheetCoordinator: UBottomSheetCoordinator!

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var locationButtion: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let locationManager = CLLocationManager()
    
    var annotations = [(Brewery, MKPointAnnotation)]() {
        didSet {
            bottomSheetViewController.reloadClosedBreweries()
        }
    }
    let bottomSheetViewController = BottomSheetViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapview()
        setupLocation()
        setupStyle()
    }
    
    func setupStyle() {
        reloadButton.setTitle("", for: .normal)
        locationButtion.setTitle("", for: .normal)
    }
    
    func getClosestBreweriesFrom(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        activityIndicator.isHidden = false
        reloadButton.isHidden = true
        BreweryNetwork.shared.getClosestBreweriesFrom(latitude: "\(latitude)", longitude: "\(longitude)") { [weak self] breweries in
            var increment = 0
            
            let geocoder = CLGeocoder()

            var mutableBreweries = [Brewery]()
            for brewery in breweries {
                if brewery.latitude != nil && brewery.longitude != nil {
                    mutableBreweries.append(brewery)
                    increment += 1
                    if increment == breweries.count {
                        self?.addAnnotations(breweries: breweries)
                    }
                } else {
                    let adress = "\(brewery.street ?? "") \(brewery.address_2 ?? "") \(brewery.address_3 ?? "")\n\(brewery.postal_code ?? "") \(brewery.city)"
                    geocoder.geocodeAddressString(adress) { placemarks, _ in
                        var mutableBrewery = brewery
                        if let longitude = placemarks?.first?.location?.coordinate.longitude,
                           let latitude = placemarks?.first?.location?.coordinate.latitude {
                            mutableBrewery.latitude = "\(latitude)"
                            mutableBrewery.longitude = "\(longitude)"
                            mutableBreweries.append(mutableBrewery)
                            increment += 1
                            
                            if increment == breweries.count {
                                self?.addAnnotations(breweries: breweries)
                            }
                        } else {
                            increment += 1
                            if increment == breweries.count {
                                self?.addAnnotations(breweries: breweries)
                            }
                        }
                    }
                }
            }
            self?.activityIndicator.isHidden = true
            self?.reloadButton.isHidden = false
        } failure: { [weak self] error in
            self?.activityIndicator.isHidden = true
            self?.reloadButton.isHidden = false
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setupBottomSheet()
    }
}
