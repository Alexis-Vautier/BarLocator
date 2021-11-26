//
//  BreweryItemCell.swift
//  BarLocator
//
//  Created by Alexis Vautier on 26/11/2021.
//

import UIKit

class BreweryItemCell: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        leftImageView.tintColor = UIColor.red
    }
    
    func configure(brewery: Brewery){
        nameLabel.text = brewery.name
        descriptionLabel.text = brewery.phone
        leftImageView.image = UIImage(named: "bier")
    }
}
