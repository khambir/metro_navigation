//
//  RouteViewController.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 4/25/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import CoreLocation
import UIKit

class RouteViewController: UIViewController {
    
    // MARK: - Properties
    fileprivate var toMetroStation: MetroStation? {
        didSet {
            routePanelView.toButton.setTitle(toMetroStation?.name, for: .normal)
            buildRoute()
        }
    }
    fileprivate var fromMetroStation: MetroStation? {
        didSet {
            routePanelView.fromButton.setTitle(fromMetroStation?.name, for: .normal)
            buildRoute()
        }
    }
    fileprivate var routePoint = RoutePoint.from
    fileprivate var geolocationManager = GeolocationManager()
    fileprivate var metroStations = MetroNavigation.shared.metroStations
    fileprivate var paths: [Path] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var routePanelView: RoutePanelView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Methods
    private func initCell() {
        let nib = UINib(nibName: String(describing: RouteStationTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: RouteStationTableViewCell.identifier)
    }
    
    private func buildRoute() {
        guard   let fromMetroStation = fromMetroStation,
                let toMetroStation = toMetroStation,
                toMetroStation.id != fromMetroStation.id,
                let shortestPath = DijkstraAlgorithm.getShortestPath(from: fromMetroStation, to: toMetroStation)
            else {
                paths = []
                return
        }
        paths = shortestPath.getHistory(from: fromMetroStation)
    }
    
    // MARK: - UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        Route.loadAll()
        initCell()
        geolocationManager.geoManagerDelegate = self
        routePanelView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch getIdentifierCase(for: segue) {
        case .showSearchView:
            let navigationController = segue.destination as? UINavigationController
            guard let controller = navigationController?.topViewController as? SearchTableViewController else { return }
            controller.delegate = self
        case .unnamed: break
        }
    }
    
}

// MARK: - UITableViewDelegate functions
extension RouteViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource functions
extension RouteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RouteStationTableViewCell.identifier) as? RouteStationTableViewCell else { return UITableViewCell() }
        guard let stationID = paths[indexPath.row].destination?.id, let metroStation = (metroStations.filter { $0.id == stationID }).first else { return UITableViewCell() }
        cell.stationNameLabel.text = metroStation.name
        let arriveDate = Date().addingTimeInterval(TimeInterval(paths[indexPath.row].total * 60))
        cell.timeLabel.text = arriveDate.timeString
        cell.branchIndicatorImageView.tintColor = metroStation.color
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paths.count
    }
    
}

// MARK: - RoutePanelViewDelegate functions
extension RouteViewController: RoutePanelViewDelegate {

    func routePanelViewToButtonDidTap(_ routePanelView: RoutePanelView) {
        routePoint = .to
        performSegue(withIdentifier: RouteViewControllerSegue.showSearchView.rawValue, sender: self)
    }
    
    func routePanelViewFromButtonDidTap(_ routePanelView: RoutePanelView) {
        routePoint = .from
        performSegue(withIdentifier: RouteViewControllerSegue.showSearchView.rawValue, sender: self)
    }
    
    func routePanelViewSwapButtonDidTap(_ routePanelView: RoutePanelView) {
        if fromMetroStation != nil && toMetroStation != nil {
            let tmp = fromMetroStation
            fromMetroStation = toMetroStation
            toMetroStation = tmp
        }
    }
    
}

// MARK: - SegueHandler support
extension RouteViewController: SegueHandler {

    typealias ViewControllerSegue = RouteViewControllerSegue

    enum RouteViewControllerSegue: String {
        case showSearchView
        case unnamed = ""
    }

}

// MARK: - SearchTableViewControllerDelegate functions
extension RouteViewController: SearchTableViewControllerDelegate {
    
    func searchTableViewController(_ searchTableViewController: SearchTableViewController, didSelectMetroStation metroStation: MetroStation) {
        switch routePoint {
        case .from: fromMetroStation = metroStation
        case .to: toMetroStation = metroStation
        }
    }
    
}

// MARK: - GeolocationManagerDelegate functions
extension RouteViewController: GeolocationManagerDelegate {
    
    func geolocationManager(_ geolocationManager: GeolocationManager, receivedNewLocation location: CLLocation) {
        if fromMetroStation == nil {
            fromMetroStation = metroStations.sorted { $0.location.distance(from: location) < $1.location.distance(from: location) }.first
        }
    }
    
}
