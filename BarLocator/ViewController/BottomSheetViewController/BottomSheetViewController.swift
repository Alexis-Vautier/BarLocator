//
//  BottomSheetViewController.swift
//  BarLocator
//
//  Created by Alexis Vautier on 24/11/2021.
//

import UIKit
import CoreLocation
import MapKit
import UBottomSheet

class BottomSheetViewController: UIViewController {
    @IBOutlet weak var searchViewDetails: UIView!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var breweryDetails: UIView!
    @IBOutlet weak var breweryClose: UIButton!
    
    @IBOutlet weak var breweryName: UILabel!
    @IBOutlet weak var breweryAdress: UITextView!
    @IBOutlet weak var breweryWebsite: UITextView!
    @IBOutlet weak var breweryPhone: UITextView!
    
    @IBOutlet weak var breweryFavoriteButton: UIButton!
    
    var brewery: Brewery?
    var searchResults = [Brewery]() {
        didSet {
            tableView.reloadData()
        }
    }

    var sheetCoordinator: UBottomSheetCoordinator?
    weak var mapViewControllerDelegate: MapViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sheetCoordinator?.startTracking(item: self)
    }
    
    func reloadClosedBreweries() {
        tableView.reloadData()
    }
}

extension BottomSheetViewController: Draggable{
    func draggableView() -> UIScrollView? {
        return tableView
    }
}

protocol DetailsSheetDelegate: AnyObject {
    func shouldDisplayDetailsOf(brewery: Brewery)
}

extension BottomSheetViewController: DetailsSheetDelegate {
    func shouldDisplayDetailsOf(brewery: Brewery) {
        showBreweryDetail(brewery: brewery)
    }
}
