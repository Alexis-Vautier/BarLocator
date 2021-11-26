//
//  BreweryCollectionCell.swift
//  BarLocator
//
//  Created by Alexis Vautier on 26/11/2021.
//

import Foundation
import SwiftyGif
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
        
        if let distance = distance {
            distanceLabel.text = distance
        } else {
            distanceLabel.text = ""
        }
        
        if brewery.isFavorited() {
            if let image = try? UIImage(gifName: "beer-gif", levelOfIntegrity: .default) {
                leftImageView.setGifImage(image)
            } else {
                leftImageView.animationManager?.deleteImageView(leftImageView)
                leftImageView.clear()
                
                leftImageView.image = UIImage(named: "bier")
            }
        } else {
            leftImageView.animationManager?.deleteImageView(leftImageView)
            leftImageView.clear()
            
            leftImageView.image = UIImage(named: "bier")
        }
    }


}
