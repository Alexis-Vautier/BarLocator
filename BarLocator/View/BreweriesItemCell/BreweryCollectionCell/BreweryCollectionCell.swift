//
//  BreweryCollectionCell.swift
//  BarLocator
//
//  Created by Alexis Vautier on 26/11/2021.
//

import Foundation
import UIKit

class BreweryCollectionCell: UICollectionViewCell {
    static let kReuseIdentifier = "BreweryCollectionCell"

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(brewery: Brewery, distance: String?){
        nameLabel.text = brewery.name
        leftImageView.image = UIImage(named: "bier")
        
        if let distance = distance {
            distanceLabel.text = distance
        } else {
            distanceLabel.text = ""
        }
    }


}
