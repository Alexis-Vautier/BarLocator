//
//  BreweriesItemCell.swift
//  BarLocator
//
//  Created by Alexis Vautier on 24/11/2021.
//

import CoreLocation
import UIKit

class BreweriesItemCell: UITableViewCell {
    let locationManager = CLLocationManager()

    weak var detailsSheetDelegate: DetailsSheetDelegate?
    private let breweryReuseIdentifier = "breweryCell"
    @IBOutlet weak var collectionView: UICollectionView!
    var breweries = [Brewery]()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        collectionView.register(UINib(nibName: "BreweryCollectionCell", bundle: nil), forCellWithReuseIdentifier: "breweryCell")
    }
    
    func configure(breweries: [Brewery]){
        self.breweries = breweries
        collectionView.reloadData()
    }
}

extension BreweriesItemCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.breweries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200.0, height: 100.0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: breweryReuseIdentifier, for: indexPath) as? BreweryCollectionCell {
            let brewery = self.breweries[indexPath.row]
            
            if let userLocation = locationManager.location,
               let latitude = Double(brewery.latitude ?? ""),
               let longitude = Double(brewery.longitude ?? "") {
                let distance = Int(userLocation.distance(from: CLLocation(latitude: latitude, longitude: longitude)))
                
                if distance < 1000 {
                    cell.configure(brewery: brewery, distance: "\(distance)m")
                } else {
                    cell.configure(brewery: brewery, distance: "\(distance / 1000)km")
                }
            } else {
                cell.configure(brewery: brewery, distance: nil)
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if breweries.count > indexPath.row {
            let brewery = breweries[indexPath.row]
            detailsSheetDelegate?.shouldDisplayDetailsOf(brewery: brewery)
        }
    }
}


