//
//  Realm+Extensions.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//


import Foundation
import RealmSwift
import RxSwift

extension Realm {
    // Idea taken from: https://github.com/realm/realm-cocoa/issues/4511
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}

extension Reactive where Base: Realm {
    func save<T: Object>(_ object: T, update: Bool = true, withApiModel: Bool = true) -> Observable<Lce<T>> {
        return Observable.create { observer in
            do {
                self.base.refresh()
                try self.base.safeWrite {
                    // Create new object if it doesn't exists or partially update existing one
                    if !object.exists() {
                        self.base.add(object, update: update)
                    } else {
                        self.base.create(T.self, value: withApiModel ? object.apiModel() : object.fullModel(), update: update)
                    }
                }
                observer.onNext(Lce<T>(data: object))
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func save<T: Object>(_ objects: [T], update: Bool = true, withApiModel: Bool = true) -> Observable<Lce<[T]>> {
        return Observable.create { observer in
            do {
                self.base.refresh()
                try self.base.safeWrite {
                    for object in objects {
                        // Create new object if it doesn't exists or partially update existing one
                        if !object.exists() {
                            self.base.add(object, update: update)
                        } else {
                            self.base.create(T.self, value: withApiModel ? object.apiModel() : object.fullModel(), update: update)
                        }
                    }
                }
                observer.onNext(Lce<[T]>(data: objects))
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func appendToList<T: Object>(_ list: List<T>, objects: [T], update: Bool = true, withApiModel: Bool = true) -> Observable<Lce<[T]>> {
        return Observable.create { observer in
            do {
                self.base.refresh()
                try self.base.safeWrite {
                    // It's not possible to append objects directly (nested objects won't be updated)
                    // Instead we have to append a reference for every object
                    // Idea taken from: https://stackoverflow.com/a/40595430/6947225
                    for object in objects {
                        // Create new object if it doesn't exists or partially update existing one
                        if !object.exists() {
                            self.base.add(object, update: update)
                        } else {
                            self.base.create(T.self, value: withApiModel ? object.apiModel() : object.fullModel(), update: update)
                        }
                        // Append reference if it isn't already in the list
                        if let objectReference = self.base.object(ofType: T.self, forPrimaryKey: object["id"]) {
                            let listIds = list.toArray().map { $0["id"] as! Int }
                            if !listIds.contains(object["id"] as! Int) {
                                list.append(objectReference)
                            }
                        }
                    }
                }
                observer.onNext(Lce<[T]>(data: list.toArray()))
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func delete<T: Object>(_ object: T) -> Observable<Lce<Void>> {
        return Observable.create { observer in
            do {
                try self.base.write {
                    self.base.delete(object)
                }
                observer.onNext(Lce<Void>(data: Void()))
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
