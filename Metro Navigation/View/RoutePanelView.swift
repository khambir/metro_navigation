//
//  RoutePanelView.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 4/25/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import UIKit

class RoutePanelView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var toButton: UIButton!
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Methods
    private func setup() {
        guard let view = loadView() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func loadView() -> UIView? {
        let bundle = Bundle(for: RoutePanelView.self)
        let nib = UINib(nibName: String(describing: RoutePanelView.self), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        return view
    }
    
}

// MARK: - Actions
extension RoutePanelView {

    @IBAction func fromButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func toButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func swap(_ sender: UIButton) {
        
    }
    
}
