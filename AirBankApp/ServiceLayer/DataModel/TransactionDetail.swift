//
//  TransactionDetail.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - Account model object
@objcMembers final class TransactionDetail: CodableObject {
    
    // MARK: Stored properties
    dynamic var id: Int = 0
    dynamic var accountNumber: String = ""
    dynamic var accountName: String = ""
    dynamic var bankCode: String = ""
    
    // MARK: Realm API
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: Mapping
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case accountNumber = "accountNumber"
        case accountName = "accountName"
        case bankCode = "bankCode"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        accountNumber = try container.decodeIfPresent(String.self, forKey: .accountNumber) ?? ""
        accountName = try container.decodeIfPresent(String.self, forKey: .accountName) ?? ""
        bankCode = try container.decodeIfPresent(String.self, forKey: .bankCode) ?? ""
    }
    
    // MARK: Encodable
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(accountNumber, forKey: .accountNumber)
        try container.encodeIfPresent(accountName, forKey: .accountName)
        try container.encodeIfPresent(bankCode, forKey: .bankCode)
        
    }
    
}

