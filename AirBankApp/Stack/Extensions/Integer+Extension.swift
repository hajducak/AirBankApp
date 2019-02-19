//
//  Integer+Extension.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation

struct Number {
    static let separator : String = {
        return "\u{2008}"
    }()
    static let formatterWithSepator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = separator
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Int {
    var stringFormatedWithSepator: String {
        return Number.formatterWithSepator.string(from: NSNumber(value: self)) ?? ""
    }
}

