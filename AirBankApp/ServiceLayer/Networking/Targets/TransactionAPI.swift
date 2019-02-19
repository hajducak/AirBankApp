//
//  TransactionAPI.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import Moya

enum TransactionAPI {
    case getTransactions()
    case getTransactionDetail(id: Int)
}

extension TransactionAPI: TargetType {
    
    var baseURL: URL { return URL(string: "\(NetworkingConstants.mockServerBaseUrl)")! }
    
    var path: String {
        switch self {
        case .getTransactions:
            return "/transactions"
        case .getTransactionDetail(let id):
            return "/transactions/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTransactions, .getTransactionDetail:
            return .get
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var task: Task {
        switch self {
        case .getTransactions:
            return .requestPlain
        case .getTransactionDetail(let id):
            let params = ["transaction_id" : id]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getTransactions:
            return NetworkingUtilities.stubbedResponse("Transaction")
        case .getTransactionDetail:
            return NetworkingUtilities.stubbedResponse("TransactionDetail")
        }
    }
    
}
