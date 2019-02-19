//
//  ShadowView.swift
//  Volvista
//
//  Created by Petr Chmelar on 04/10/2018.
//  Copyright © 2018 Qest. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2
    }
    
}
