//
//  TransactionService.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RealmSwift
import RxRealm

protocol HasTransactionsService {
    var transactionsService: TransactionsService { get }
}

class TransactionsService: BaseService {
    
    func getTransaction() -> Observable<Lce<[Transaction]>> {
        let endpoint = TransactionAPI.getTransactions()
        
        return self.provider.request(MultiTarget(endpoint)).asObservable().filterSuccess().map([Transaction].self, atKeyPath: "items").flatMap({ (transactions) ->  Observable<Lce<[Transaction]>> in
                return Observable.just(Lce.init(data: transactions))
        }).catchError({
            (error) in error.asServiceError()
        })
    }
    
    func getTransactionDetail(id: Int) -> Observable<Lce<TransactionDetail>> {
        let endpoint = TransactionAPI.getTransactionDetail(id: id)
        
        return self.provider.request(MultiTarget(endpoint)).asObservable().filterSuccess().map(TransactionDetail.self, atKeyPath: "contraAccount").flatMap({ (transactionDetail) -> Observable<Lce<TransactionDetail>> in
            return Observable.just(Lce.init(data: transactionDetail))
        }).catchError({
            (error) in error.asServiceError()
        })
    }

}

