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
        willSet {
            routePanelView.toButton.setTitle(newValue?.name, for: .normal)
        }
    }
    fileprivate var fromMetroStation: MetroStation? {
        willSet {
            routePanelView.fromButton.setTitle(newValue?.name, for: .normal)
        }
    }
    fileprivate var routePoint = RoutePoint.from
    fileprivate var geolocationManager = GeolocationManager()
    fileprivate var metroStations = MetroStation.loadAll()
    
    // MARK: - Outlets
    @IBOutlet weak var routePanelView: RoutePanelView!
    
    // MARK: - UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
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
