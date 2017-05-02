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
            updateRouteInfo()
        }
    }
    fileprivate var fromMetroStation: MetroStation? {
        didSet {
            routePanelView.fromButton.setTitle(fromMetroStation?.name, for: .normal)
            buildRoute()
            updateRouteInfo()
        }
    }
    fileprivate var routePoint = RoutePoint.from
    fileprivate var geolocationManager = GeolocationManager()
    fileprivate var metroStations = MetroNavigation.shared.metroStations
    fileprivate var paths: [Path] = [] {
        didSet {
            routePanelView.routeInfoView.isHidden = paths.isEmpty
            tableView.reloadData()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var routePanelView: RoutePanelView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var stationPopUpView: StationPopUpView!
    
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
    
    private func updateRouteInfo() {
        let travelTime = TimeInterval((paths.last?.total ?? 0) * 60)
        var travelTimeString = ""
        if travelTime.dateComponents.hours > 0 {
            travelTimeString += "\(TimeInterval(travelTime).dateComponents.hours) " + "hour".localized
        }
        if travelTime.dateComponents.minutes > 0 {
            travelTimeString += "\(TimeInterval(travelTime).dateComponents.minutes) " + "minutes".localized
        }
        routePanelView.travelTimeLabel.text = travelTimeString
        routePanelView.arriveTimeLabel.text = "arriveAt".localized + Date().addingTimeInterval(travelTime).timeString
    }
    
    // MARK: - UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        Route.loadAll()
        initCell()
        stationPopUpView.delegate = self
        geolocationManager.geoManagerDelegate = self
        routePanelView.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stationPopUpView.removeFromSuperview()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        guard let selectedStation = paths[selectedIndexPath.row].destination as? MetroStation else { return }
        stationPopUpView.stationNameLabel.text = selectedStation.name
        stationPopUpView.branchIndicatorView.backgroundColor = selectedStation.color
        stationPopUpView.add(to: view)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        stationPopUpView.removeFromSuperview()
    }
    
}

// MARK: - UITableViewDataSource functions
extension RouteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RouteStationTableViewCell.identifier) as? RouteStationTableViewCell else { return UITableViewCell() }
        guard let stationID = paths[indexPath.row].destination?.id, let metroStation = (metroStations.filter { $0.id == stationID }).first else { return UITableViewCell() }
        cell.delegate = self
        cell.stationNameLabel.text = metroStation.name
        let arriveDate = Date().addingTimeInterval(TimeInterval(paths[indexPath.row].total * 60))
        cell.timeLabel.text = arriveDate.timeString
        cell.branchIndicatorImageView.tintColor = metroStation.color
        let isExtremeStation = indexPath.row == 0 || indexPath.row == paths.count - 1
        cell.mapButton.isHidden = !isExtremeStation
        cell.timeLabel.isHidden = !cell.mapButton.isHidden
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paths.count
    }
    
}

// MARK: - RouteStationTableViewCellDelegate functions
extension RouteViewController: RouteStationTableViewCellDelegate {
    
    func routeStationCellMapButtonDidTap(_ routeStationCell: RouteStationTableViewCell) {
        guard let indexPath = tableView.indexPath(for: routeStationCell),
            let selectedStation = paths[indexPath.row].destination as? MetroStation
            else { return }
        showLocationUtilsList(for: selectedStation)
    }
    
    private func showLocationUtilsList(for metroStation: MetroStation) {
        let alert = UIAlertController(title: "getDirection".localized, message: nil, preferredStyle: .actionSheet)
        for locationUtil in LocationUtilManager.installedUtilities {
            let utilAction = UIAlertAction(title: locationUtil.applicationName, style: .default) { _ in
                locationUtil.openAndBuildRoute(to: metroStation.location.coordinate)
            }
            alert.addAction(utilAction)
        }
        
        let cancel = UIAlertAction(title: "cancel".localized, style: .cancel)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
}

// MARK: - StationPopUpViewDelegate functions
extension RouteViewController: StationPopUpViewDelegate {
    
    func stationPopUpViewToButtonDidTap(_ stationPupUpView: StationPopUpView) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        toMetroStation = paths[selectedIndexPath.row].destination as? MetroStation
        stationPopUpView.removeFromSuperview()
    }
    
    func stationPopUpViewFromButtonDidTap(_ stationPupUpView: StationPopUpView) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        fromMetroStation = paths[selectedIndexPath.row].destination as? MetroStation
        stationPopUpView.removeFromSuperview()
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
        stationPopUpView.removeFromSuperview()
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
