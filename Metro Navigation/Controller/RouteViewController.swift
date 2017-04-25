//
//  RouteViewController.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 4/25/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import UIKit

class RouteViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var routeInfoView: UIView!
    @IBOutlet weak var routePanelView: RoutePanelView!
    
    // MARK: - UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        routePanelView.delegate = self
    }
    
}

// MARK: - RoutePanelViewDelegate functions
extension RouteViewController: RoutePanelViewDelegate {

    func routePanelViewToButtonDidTap(_ routePanelView: RoutePanelView) {
        
    }
    
    func routePanelViewFromButtonDidTap(_ routePanelView: RoutePanelView) {
        
    }
    
    func routePanelViewSwapButtonDidTap(_ routePanelView: RoutePanelView) {
        
    }
    
}
