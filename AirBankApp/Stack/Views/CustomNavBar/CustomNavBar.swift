//
//  CustomNavBar.swift
//  Volvista
//
//  Created by Viktor Kaderabek on 22/11/2018.
//  Copyright © 2018 Qest. All rights reserved.
//

import UIKit

class CustomNavBar: XIBView {

    override var nibName: String {
        return CustomNavBar.nameOfClass
    }
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
