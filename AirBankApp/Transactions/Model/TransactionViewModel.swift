//
//  TransactionViewModel.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TransactionViewModel: ViewModelType {
    
    typealias Dependencies = HasTransactionsService
    
    fileprivate let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        let transactionDetail = input.nextTransactionDetail.flatMap { (input) -> Observable<Lce<TransactionDetail>> in
            return self.dependencies.transactionsService.getTransactionDetail(id: input).startWith(Lce(loading: true))
        }.asDriverOnErrorJustComplete()
        
        let transactionsReqest = self.dependencies.transactionsService.getTransaction().asDriverOnErrorJustComplete()
        
        return Output(transactionsReqest: transactionsReqest, transactionDetail: transactionDetail)
    }
}

extension TransactionViewModel {
    struct Input {
        let nextTransactionDetail: PublishSubject<(Int)>
    }
    
    struct Output {
        let transactionsReqest: Driver<Lce<[Transaction]>>
        let transactionDetail: Driver<Lce<TransactionDetail>>
    }
}
