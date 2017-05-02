//
//  StationPopUpView.swift
//  Metro Navigation
//
//  Created by Vladislav Khambir on 5/2/17.
//  Copyright © 2017 Vladislav Khambir. All rights reserved.
//

import UIKit

protocol StationPopUpViewDelegate: class {
    func stationPupUpViewFromButtonDidTap(_ stationPupUpView: StationPopUpView)
    func stationPupUpViewToButtonDidTap(_ stationPupUpView: StationPopUpView)
}

class StationPopUpView: UIView {
    
    // MARK: - Properties
    internal weak var delegate: StationPopUpViewDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var branchIndicatorView: UIView!
    
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
        view.addShadow()
        addSubview(view)
    }
    
    private func loadView() -> UIView? {
        let bundle = Bundle(for: StationPopUpView.self)
        let nib = UINib(nibName: String(describing: StationPopUpView.self), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        return view
    }
    
    internal func add(to view: UIView) {
        center = view.center
        view.addSubview(self)
    }

}

// MARK: - Actions
extension StationPopUpView {
    
    @IBAction func fromButtonAction(_ sender: UIButton) {
        delegate?.stationPupUpViewFromButtonDidTap(self)
    }
    
    @IBAction func toButtonAction(_ sender: UIButton) {
        delegate?.stationPupUpViewToButtonDidTap(self)
    }
    
}
