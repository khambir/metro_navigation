//
//  SearchTableViewController.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 4/25/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import CoreLocation
import UIKit

class SearchTableViewController: UITableViewController {
    
    // MARK: - Properties
    private var geolocationManager = GeolocationManager()
    
    // MARK: - Outlet
    @IBOutlet var searchBar: UISearchBar!
    
    // MARK: - UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        geolocationManager.startLocationManager()
        geolocationManager.geoManagerDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - Actions
extension SearchTableViewController {

    @IBAction func cancelSearch(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}

// MARK: - UISearchBarDelegate
extension SearchTableViewController: UISearchBarDelegate {
    
}

extension SearchTableViewController: GeolocationManagerDelegate {

    func geolocationManager(_ geolocationManager: GeolocationManager, receivedNewLocation location: CLLocation) {
        print(location)
    }
    
}
 
