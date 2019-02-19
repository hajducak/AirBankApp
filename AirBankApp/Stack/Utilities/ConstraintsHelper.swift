//
//  ConstraintsHelper.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ConstraintsHelper: NSObject {
    
    class func getSafeAreaInsets() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.keyWindow {
                return window.safeAreaInsets
            }
        }
        return UIEdgeInsets()
    }
    
    // Constraint to view bounds
    class func setConstraintToCoverView(containerView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        let horConstraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let verConstraint = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        let widConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: containerView, attribute: .width, multiplier: 1.0, constant: 0.0)
        let heiConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal,toItem: containerView, attribute: .height,multiplier: 1.0, constant: 0.0)
        containerView.addConstraints([horConstraint, verConstraint, widConstraint, heiConstraint])
    }
    
    // Constraint to center in view
    class func setConstraintToCenterView(containerView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        let horConstraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let verConstraint = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        containerView.addConstraints([horConstraint, verConstraint])
    }
    
}
