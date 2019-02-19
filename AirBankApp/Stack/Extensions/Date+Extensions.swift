//
//  Date+Extensions.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation

extension Date {
    
    enum DateFormat : String {
        case ddMMyyyyHHmm = "dd. MM. yyyy, HH:mm"
        case EEddMMMyyyHHmmZ = "EE, dd MMM yyyy HH:mm Z"
        case ddMMyyyy = "dd. MM. yyyy"
        case HHmm = "HH:mm"
    }
    
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.ddMMyyyy.rawValue
        return  formatter.string(from: self)
    }
    
    var time: String {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.HHmm.rawValue
        return  formatter.string(from: self)
    }
    
    func iso8601(dateFormat: String = NetworkingConstants.iso8601DefaultFormat, timeZone: TimeZone? = TimeZone.current) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = timeZone
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
    
    static func dateFromString(_ stringDate: String, dateFormat: String = DateFormat.EEddMMMyyyHHmmZ.rawValue) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from:stringDate)
        return date
    }
    
    static func stringFromDate(_ date: Date, dateFormat: String = DateFormat.ddMMyyyyHHmm.rawValue) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let string = dateFormatter.string(from: date)
        return string
    }
}

