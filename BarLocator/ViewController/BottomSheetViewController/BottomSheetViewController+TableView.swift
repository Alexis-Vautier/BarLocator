//
//  BottomSheetViewController+TableView.swift
//  BarLocator
//
//  Created by Alexis Vautier on 26/11/2021.
//

import CoreLocation
import Foundation
import UIKit

extension BottomSheetViewController: UITableViewDelegate, UITableViewDataSource{
    func setupTableView() {
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BreweriesItemCell", bundle: nil), forCellReuseIdentifier: "BreweriesItemCell")
        tableView.register(UINib(nibName: "BreweryItemCell", bundle: nil), forCellReuseIdentifier: "BreweryItemCell")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if searchBar.isFirstResponder {
            return 1
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.isFirstResponder {
            return searchResults.count
        }
        switch section {
        case 0:
            if mapViewControllerDelegate?.getClosedBreweries().isEmpty ?? true {
                return 0
            } else {
                return 1
            }
        case 1:
            if let data = UserDefaults.standard.value(forKey:"favorites") as? Data,
               let favoritesBreweries = try? PropertyListDecoder().decode(Array<Brewery>.self, from: data) {
                return favoritesBreweries.count
            } else { return 0 }
        default:
            if let data = UserDefaults.standard.value(forKey:"history") as? Data,
               let favoritesBreweries = try? PropertyListDecoder().decode(Array<Brewery>.self, from: data) {
                return favoritesBreweries.count
            } else { return 0 }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchBar.isFirstResponder {
            return "Résultats"
        }
        switch section {
        case 0:
            if mapViewControllerDelegate?.getClosedBreweries().isEmpty ?? true {
                return nil
            } else {
                return "À proximité"
            }
        case 1:
            return "Favoris"
        default:
            return "Historique"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if searchBar.isFirstResponder {
            return .leastNormalMagnitude
        }

        if section == 0 {
            if mapViewControllerDelegate?.getClosedBreweries().isEmpty ?? true {
                return 0
            } else {
                return .leastNormalMagnitude
            }
        }
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchBar.isFirstResponder {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "BreweryItemCell", for: indexPath) as? BreweryItemCell,
               searchResults.count > indexPath.row {
                
                let brewery = searchResults[indexPath.row]
                let formattedDistance = brewery.getFormattedDistanceFrom(location: locationManager.location)
                cell.configure(brewery: brewery, distance: formattedDistance)
                return cell
            } else {
                return UITableViewCell()
            }
        }

        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "BreweriesItemCell", for: indexPath) as? BreweriesItemCell,
               let closedBreweries = mapViewControllerDelegate?.getClosedBreweries(),
               closedBreweries.count > indexPath.row {
                
                cell.configure(breweries: closedBreweries)
                cell.detailsSheetDelegate = self
                return cell
            } else {
                return UITableViewCell()
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "BreweryItemCell", for: indexPath) as? BreweryItemCell,
               let data = UserDefaults.standard.value(forKey:"favorites") as? Data,
               let favoritesBreweries = try? PropertyListDecoder().decode(Array<Brewery>.self, from: data),
               favoritesBreweries.count > indexPath.row {
                
                let brewery = favoritesBreweries[indexPath.row]
                
                let formattedDistance = brewery.getFormattedDistanceFrom(location: locationManager.location)
                cell.configure(brewery: brewery, distance: formattedDistance)
                
                return cell
            } else {
                return UITableViewCell()
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "BreweryItemCell", for: indexPath) as? BreweryItemCell,
               let data = UserDefaults.standard.value(forKey:"history") as? Data,
               let historyBreweries = try? PropertyListDecoder().decode(Array<Brewery>.self, from: data),
               historyBreweries.count > indexPath.row {
                
                let brewery = historyBreweries[indexPath.row]
                
                let formattedDistance = brewery.getFormattedDistanceFrom(location: locationManager.location)
                cell.configure(brewery: brewery, distance: formattedDistance)
                
                return cell
            } else {
                return UITableViewCell()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchBar.isFirstResponder {
            if searchResults.count > indexPath.row {
                showBreweryDetail(brewery: searchResults[indexPath.row])
            }
        }

        switch indexPath.section {
        case 0 : break
        case 1:
            if let data = UserDefaults.standard.value(forKey:"favorites") as? Data,
               let favoritesBreweries = try? PropertyListDecoder().decode(Array<Brewery>.self, from: data),
               favoritesBreweries.count > indexPath.row {
                showBreweryDetail(brewery: favoritesBreweries[indexPath.row])
            }
        case 2:
            
            if let data = UserDefaults.standard.value(forKey:"history") as? Data,
               let historyBreweries = try? PropertyListDecoder().decode(Array<Brewery>.self, from: data),
               historyBreweries.count > indexPath.row {
                showBreweryDetail(brewery: historyBreweries[indexPath.row])
            }
        default: break
        }
    }
}
