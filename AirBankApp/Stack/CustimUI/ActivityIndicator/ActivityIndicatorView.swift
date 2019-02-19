//
//  ActivityIndicatorView.swift
//  Volvista
//
//  Created by Petr Chmelar on 04/10/2018.
//  Copyright © 2018 Qest. All rights reserved.
//

import UIKit

class ActivityIndicatorView: XIBView {
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override var nibName: String {
        return ActivityIndicatorView.nameOfClass
    }
    
}
