//
//  SearchTableViewController.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 4/25/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import CoreLocation
import UIKit

protocol SearchTableViewControllerDelegate: class {
    func searchTableViewController(_ searchTableViewController: SearchTableViewController, didSelectMetroStation metroStation: MetroStation)
}

class SearchTableViewController: UITableViewController {
    
    // MARK: - Properties
    private var geolocationManager = GeolocationManager()
    fileprivate var metroStations = MetroStation.loadAll()
    fileprivate var filteredMetroStations: [MetroStation] = []
    internal weak var delegate: SearchTableViewControllerDelegate?
    
    // MARK: - Outlet
    @IBOutlet var searchBar: UISearchBar!
    
    // MARK: - Methods
    private func initCell() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
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

// MARK: - UISearchBarDelegate functions
extension SearchTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMetroStations = metroStations.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
    
}

// MARK: - GeolocationManagerDelegate functions
extension SearchTableViewController: GeolocationManagerDelegate {

    func geolocationManager(_ geolocationManager: GeolocationManager, receivedNewLocation location: CLLocation) {
        print(location)
    }
    
}

// MARK: - UITableViewDataSource
extension SearchTableViewController {

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        let dataSource = filteredMetroStations.isEmpty ? metroStations : filteredMetroStations
        cell.textLabel?.setText(dataSource[indexPath.row].name, withBoldPart: searchBar.text ?? "")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMetroStations.isEmpty ? metroStations.count : filteredMetroStations.count
    }
    
}

// MARK: - UITableViewDelegate
extension SearchTableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMetroStantion = filteredMetroStations.isEmpty ? metroStations[indexPath.row] : filteredMetroStations[indexPath.row]
        delegate?.searchTableViewController(self, didSelectMetroStation: selectedMetroStantion)
        dismiss(animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
 
