//
//  BottomSheetViewController+DataManagement.swift
//  BarLocator
//
//  Created by Alexis Vautier on 26/11/2021.
//

import Foundation
import UIKit

extension BottomSheetViewController {
    func addToHistory() {
        guard let brewery = brewery else { return }
        
        var newHistoryBreweries = [Brewery]()

        if let historyBreweries = getHistoryBreweries() {
            newHistoryBreweries = historyBreweries
        }

        if !newHistoryBreweries.contains(where: { breweryInArray in
            brewery.id == breweryInArray.id
        }) {
            newHistoryBreweries.insert(brewery, at: 0)
        } else {
            if let index = newHistoryBreweries.firstIndex(where: { breweryInArray in
                breweryInArray.id == brewery.id
            }) {
                newHistoryBreweries.remove(at: index)
                newHistoryBreweries.insert(brewery, at: 0)
            }
        }
        
        if let encoded = try? PropertyListEncoder().encode(newHistoryBreweries) {
            UserDefaults.standard.set(encoded, forKey: kHistoryKey)
        }
        tableView.reloadData()
    }
    
    func addToFavorites() {
        guard let brewery = brewery else { return }
        
        var newFavoritesBreweries = [Brewery]()

        if let favoritesBreweries = getFavoritesBreweries() {
            newFavoritesBreweries = favoritesBreweries
        }
        
        if !newFavoritesBreweries.contains(where: { breweryInArray in
            brewery.id == breweryInArray.id
        }) {
            newFavoritesBreweries.append(brewery)
        }
        
        if let encoded = try? PropertyListEncoder().encode(newFavoritesBreweries) {
            UserDefaults.standard.set(encoded, forKey: kFavoritesKey)
            breweryFavoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            breweryFavoriteButton.setTitle(" Retirer des Favoris", for: .normal)
        }
        tableView.reloadData()
    }
    
    func removeFromFavorites() {
        guard let brewery = brewery else { return }
        
        var newFavoritesBreweries = [Brewery]()

        if let favoritesBreweries = getFavoritesBreweries() {
            newFavoritesBreweries = favoritesBreweries
        }
        

        if newFavoritesBreweries.contains(where: { breweryInArray in
            brewery.id == breweryInArray.id
        }) {
            if let index = newFavoritesBreweries.firstIndex(where: { breweryInArray in
                breweryInArray.id == brewery.id
            }) {
                newFavoritesBreweries.remove(at: index)
            }
        }
        
        if let encoded = try? PropertyListEncoder().encode(newFavoritesBreweries) {
            UserDefaults.standard.set(encoded, forKey: kFavoritesKey)
            breweryFavoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            breweryFavoriteButton.setTitle(" Ajouter aux Favoris", for: .normal)
        }
        tableView.reloadData()
    }
}

extension BottomSheetViewController {
    func isFavorited(brewery: Brewery?) -> Bool {
        guard let brewery = brewery else {
            return false
        }
        
        if let favoritesBreweries = getFavoritesBreweries() {
            if favoritesBreweries.contains(where: { breweryInArray in
                brewery.id == breweryInArray.id
            }) {
                return true
            } else {
                return false
            }
        } else { return false }
    }
}

extension BottomSheetViewController {
    func getFavoritesBreweries() -> [Brewery]? {
        if let data = UserDefaults.standard.value(forKey:kFavoritesKey) as? Data,
           let favoritesBreweries = try? PropertyListDecoder().decode(Array<Brewery>.self, from: data) {
            return favoritesBreweries
        } else { return nil }
    }
    
    func getHistoryBreweries() -> [Brewery]? {
        if let data = UserDefaults.standard.value(forKey:kHistoryKey) as? Data,
           let historyBreweries = try? PropertyListDecoder().decode(Array<Brewery>.self, from: data) {
            return historyBreweries
        } else { return nil }
    }
}
