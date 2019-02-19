//
//  NSObject+Extensions.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation

extension NSObject {
    
    /// class name literal
    public class var nameOfClass: String {
        get {
            guard let className = NSStringFromClass(self).components(separatedBy: ".").last else {
                return "N/A"
            }
            return className
        }
    }
}

