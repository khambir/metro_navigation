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
    fileprivate var geolocationManager = GeolocationManager()
    fileprivate var metroStations = MetroStation.loadAll()
    fileprivate var filteredMetroStations: [MetroStation] = []
    internal weak var delegate: SearchTableViewControllerDelegate?
    
    // MARK: - Outlet
    @IBOutlet var searchBar: UISearchBar!
    
    // MARK: - Methods
    private func initCell() {
        let nib = UINib(nibName: String(describing: SearchStantionTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: SearchStantionTableViewCell.identifier)
    }
    
    // MARK: - UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        initCell()
        navigationItem.titleView = searchBar
        geolocationManager.geoManagerDelegate = self
        tableView.hideBottomEmptyCells()
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
        metroStations.sort { $0.location.distance(from: location) < $1.location.distance(from: location) }
        filteredMetroStations.sort { $0.location.distance(from: location) < $1.location.distance(from: location) }
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource
extension SearchTableViewController {

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchStantionTableViewCell.identifier) as? SearchStantionTableViewCell else { return UITableViewCell() }
        let dataSource = filteredMetroStations.isEmpty ? metroStations : filteredMetroStations
        cell.stationNameLabel.setText(dataSource[indexPath.row].name, withBoldPart: searchBar.text ?? "")
        cell.branchIndicatorView.backgroundColor = dataSource[indexPath.row].color
        if let deviceLocation = geolocationManager.location {
            let distanceToStation = round(dataSource[indexPath.row].location.distance(from: deviceLocation) / 1000 * 10) / 10
            cell.distanceLabel.text = "\(distanceToStation) km"
        }
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
 
