//
//  BottomSheetViewController+UISearchBarDelegate.swift
//  BarLocator
//
//  Created by Alexis Vautier on 26/11/2021.
//

import CoreLocation
import Foundation
import UIKit

extension BottomSheetViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        mapViewControllerDelegate?.shouldExpand(animated: true)
        
        if searchText.count >= 3 {
            BreweryNetwork.shared.getClosestBreweriesUsing(name: searchText) { [weak self] breweriesResult in
                var increment = 0
                

                var mutableBreweries = [Brewery]()
                for brewery in breweriesResult {
                    if brewery.latitude != nil && brewery.longitude != nil {
                        mutableBreweries.append(brewery)
                        increment += 1
                        if increment == breweriesResult.count {
                            self?.searchResults = mutableBreweries
                        }
                    } else {
                        let adress = "\(brewery.street ?? "") \(brewery.address_2 ?? "") \(brewery.address_3 ?? "") \(brewery.postal_code ?? "") \(brewery.city)"
                        let geocoder = CLGeocoder()

                        geocoder.geocodeAddressString(adress) { placemarks, _ in
                            var mutableBrewery = brewery
                            if let longitude = placemarks?.first?.location?.coordinate.longitude,
                               let latitude = placemarks?.first?.location?.coordinate.latitude {
                                mutableBrewery.latitude = "\(latitude)"
                                mutableBrewery.longitude = "\(longitude)"
                                mutableBreweries.append(mutableBrewery)
                                increment += 1
                                
                                if increment == breweriesResult.count {
                                    self?.searchResults = mutableBreweries
                                }
                            } else {
                                increment += 1
                                if increment == breweriesResult.count {
                                    self?.searchResults = mutableBreweries
                                }
                            }
                        }
                    }
                }
            } failure: { error in
                // Handle Error
            }

        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        searchBar.text = ""
        tableView.reloadData()
        mapViewControllerDelegate?.shouldReduce(animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        mapViewControllerDelegate?.shouldExpand(animated: true)
    }
}
