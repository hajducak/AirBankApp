//
//  Transaction.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - Account model object
@objcMembers final class Transaction: CodableObject {
    
    // MARK: Stored properties
    dynamic var id: Int = 0
    dynamic var amountInAccountCurrency: Int = 0
    dynamic var direction: String = ""
    
    // MARK: Realm API
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: Mapping
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case amountInAccountCurrency = "amountInAccountCurrency"
        case direction = "direction"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        amountInAccountCurrency = try container.decodeIfPresent(Int.self, forKey: .amountInAccountCurrency) ?? 0
        direction = try container.decodeIfPresent(String.self, forKey: .direction) ?? ""
    }
    
    // MARK: Encodable
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(amountInAccountCurrency, forKey: .amountInAccountCurrency)
        try container.encodeIfPresent(direction, forKey: .direction)
        
    }
    
}

