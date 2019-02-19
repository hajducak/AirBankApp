//
//  Error+Extensions.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import RxSwift

extension Error {
    func asServiceError<T: Any>(messages: [Int : String] = [:]) -> Observable<Lce<T>> {
        if let serviceError = self as? ServiceError {
            return Observable.just(Lce(error: serviceError))
        } else {
            print(self)
            return Observable.error(self)
        }
    }
}
