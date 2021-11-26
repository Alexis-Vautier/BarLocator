//
//  BreweryAnnotationView.swift
//  BarLocator
//
//  Created by Alexis Vautier on 26/11/2021.
//

import Foundation
import MapKit

class BreweryAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let pinImage = UIImage(named: "bier") else { return }
            
            let size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContext(size)
            pinImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            self.image = resizedImage
        }
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        // Enable callout
        canShowCallout = true
        
        // Move the image a little bit above the point.
        centerOffset = CGPoint(x: 0, y: -20)
    }
}
