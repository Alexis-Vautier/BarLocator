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
    
    static let kReuseIdentifier = "BreweriesItemCell"

    weak var detailsSheetDelegate: DetailsSheetDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    var breweries = [Brewery]()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        collectionView.register(UINib(nibName: BreweryCollectionCell.kReuseIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: BreweryCollectionCell.kReuseIdentifier)
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
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreweryCollectionCell.kReuseIdentifier,
                                                         for: indexPath) as? BreweryCollectionCell {
            let brewery = self.breweries[indexPath.row]
            
            let formattedDistance = brewery.getFormattedDistanceFrom(location: locationManager.location)
            cell.configure(brewery: brewery, distance: formattedDistance)
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


