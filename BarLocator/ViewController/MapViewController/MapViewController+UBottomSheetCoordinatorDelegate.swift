//
//  MapViewController+UBottomSheetCoordinatorDelegate.swift
//  BarLocator
//
//  Created by Alexis Vautier on 26/11/2021.
//

import Foundation
import UBottomSheet
import UIKit

extension MapViewController: UBottomSheetCoordinatorDelegate{
    
    func bottomSheet(_ container: UIView?, didPresent state: SheetTranslationState) {
        self.sheetCoordinator.addDropShadowIfNotExist()
        self.handleState(state)
    }

    func bottomSheet(_ container: UIView?, didChange state: SheetTranslationState) {
        handleState(state)
    }

    func bottomSheet(_ container: UIView?, finishTranslateWith extraAnimation: @escaping ((CGFloat) -> Void) -> Void) {
        extraAnimation({ _ in })
    }
    
    func handleState(_ state: SheetTranslationState) {
        switch state {
        case .progressing(_, _): break
        case .finished(_, let percent):
            if percent < 100 {
                view.endEditing(true)
            }
        default: break
        }
    }
}

extension MapViewController {
    func setupBottomSheet() {
        guard sheetCoordinator == nil else { return }
        sheetCoordinator = UBottomSheetCoordinator(parent: self,
                                                   delegate: self)
        
        bottomSheetViewController.sheetCoordinator = sheetCoordinator
        bottomSheetViewController.mapViewControllerDelegate = self
        sheetCoordinator.addSheet(bottomSheetViewController, to: self, didContainerCreate: { container in
            let f = self.view.frame
            let rect = CGRect(x: f.minX, y: f.minY, width: f.width, height: f.height)
            container.roundCorners(corners: [.topLeft, .topRight], radius: 10, rect: rect)
        })
        sheetCoordinator.setCornerRadius(10)
        
        shouldReduce(animated: false)
    }
}
