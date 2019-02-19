//
//  XIBView.swift
//  Volvista
//
//  Created by Petr Chmelar on 04/10/2018.
//  Copyright © 2018 Qest. All rights reserved.
//

import UIKit

class XIBView: UIView {
    
    var view: UIView!
    
    var nibName : String {
        get {return "XIBView"}
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
        configureViews()
    }
    
    func configureViews() {
        
    }
    
}
