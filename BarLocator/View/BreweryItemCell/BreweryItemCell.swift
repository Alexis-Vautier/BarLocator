//
//  BreweryItemCell.swift
//  BarLocator
//
//  Created by Alexis Vautier on 26/11/2021.
//

import SwiftyGif
import UIKit

class BreweryItemCell: UITableViewCell {

    static let kReuseIdentifier = "BreweryItemCell"

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        leftImageView.tintColor = UIColor.red
    }
    
    func configure(brewery: Brewery, distance: String?) {
        leftImageView.image = nil
        nameLabel.text = brewery.name
        if let distance = distance {
            descriptionLabel.text = distance
        } else {
            descriptionLabel.text = ""
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
