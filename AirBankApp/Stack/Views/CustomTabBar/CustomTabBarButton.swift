//
//  CustomTabBarButton.swift
//  Shipvio3
//
//  Created by Petr Chmelar on 07/09/2018.
//  Copyright © 2018 Qest. All rights reserved.
//

import UIKit

class CustomTabBarButton: XIBView {
    
    /// required nib name
    override var nibName: String {
        return CustomTabBarButton.nameOfClass
    }
    
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconViewWidth: NSLayoutConstraint!
    @IBOutlet weak var mainLabel: UILabel!
    
    
    
}
