//
//  Object+Extensions.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

extension Object {
    
    // Model for partial updates of Realm objects (to prevent overwriting optional existing attributes)
    // Just override apiModel() function in your object's class and remove properties you don't want to be updated
    // Idea taken from: https://github.com/realm/realm-cocoa/issues/4882
    // Doesn't work for nested objects :(
    @objc func fullModel() -> [String : Any] {
        var model: [String : Any] = [:]
        let schema = RLMSchema.partialShared().schema(forClassName: String(describing: type(of: self).self))
        if let schema = schema {
            for property in schema.properties {
                model[property.name] = self.value(forKey: property.name)
            }
        }
        return model
    }
    
    @objc func apiModel() -> [String : Any] {
        return fullModel()
    }
    
    func exists() -> Bool {
        let realm = try! Realm()
        if let id = self.value(forKey: "id") {
            return realm.object(ofType: type(of: self).self, forPrimaryKey: id) != nil
        } else {
            return false
        }
    }
}
