//
//  BaseService.swift
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

class BaseService {
    
    let realm = try! Realm()
    let provider = AuthenticatedProvider<MultiTarget>()
    
    ///
    /// Generic function for observing on a specified object from database.
    ///
    /// - parameter id: ID to specify an object.
    /// - returns: Observable which emits Lce of a given type.
    ///
    func dbStream<T: CodableObject>(id: String, primaryKeyName: String = "id") -> Observable<Lce<T>> {
        
        let dbObjects = realm.objects(T.self).filter(NSPredicate(format: "\(primaryKeyName) == %@", id))
        
        return Observable.collection(from: dbObjects).flatMap { (objects) -> Observable<Lce<T>> in
            if let object = objects.first {
                return Observable.just(Lce(data: object))
            } else {
                return Observable.empty()
            }
        }
    }
    
    ///
    /// Generic function for observing on a specified collection of objects from database.
    ///
    /// - parameter predicate: NSPredicate for optional objects filtering.
    /// - parameter sortBy: Optional parameter for sorting.
    /// - parameter ascending: Optional parameter for sorting in ascending or descending order.
    /// - returns: Observable which emits Lce with Array of a given type.
    ///
    func dbStream<T: CodableObject>(predicate: NSPredicate? = nil, sortBy: String? = nil, ascending: Bool = false) -> Observable<Lce<[T]>> {
        
        var dbObjects = realm.objects(T.self)
        if let predicate = predicate {
            dbObjects = dbObjects.filter(predicate)
        }
        
        if let sortBy = sortBy {
            dbObjects = dbObjects.sorted(byKeyPath: sortBy, ascending: ascending)
        }
        
        return Observable.array(from: dbObjects).flatMap { (objects) -> Observable<Lce<[T]>> in
            if objects.count > 0 {
                return Observable.just(Lce(data: objects))
            } else {
                return Observable.empty()
            }
        }
    }
    
    ///
    /// Generic function for observing on a specified network call.
    /// Automatically filters out API errors, map to an object and save to database.
    ///
    /// - parameter endpoint: TargetType from Moya which specify API endpoint to be called.
    /// - parameter setPrimaryKey: Optional parameter to set object's primary key (useful for foreign key).
    /// - returns: Observable which emits Lce of a given type.
    ///
    func networkStream<T: CodableObject>(endpoint: TargetType, setPrimaryKey: Int? = nil) -> Observable<Lce<T>> {
        return provider.request(MultiTarget(endpoint)).asObservable().filterSuccess().map(T.self).flatMap({ (object) -> Observable<Lce<T>> in
            if let id = setPrimaryKey {
                object["id"] = id
            }
            return self.realm.rx.save(object)
        }).catchError({ (error) in error.asServiceError() })
    }
    
    ///
    /// Generic function for observing on a specified network call.
    /// Automatically filters out API errors, map to an object, append to a given list and save to database.
    ///
    /// - parameter endpoint: TargetType from Moya which specify API endpoint to be called.
    /// - parameter list: List that will be extented with new object.
    /// - parameter setPrimaryKey: Optional parameter to set object's primary key (useful for foreign key).
    /// - returns: Observable which emits Lce of a given type.
    ///
    func networkStreamWithAppend<T: CodableObject>(endpoint: TargetType, list: List<T>, setPrimaryKey: Int? = nil) -> Observable<Lce<T>> {
        return provider.request(MultiTarget(endpoint)).asObservable().filterSuccess().map(T.self).flatMap({ (object) -> Observable<Lce<T>> in
            if let id = setPrimaryKey {
                object["id"] = id
            }
            return self.realm.rx.appendToList(list, objects: [object]).map({ _ in Lce<T>(data: object) })
        }).catchError({ (error) in error.asServiceError() })
    }
    
    ///
    /// Generic function for observing on a specified network call.
    /// Automatically filters out API errors, map to an array and save to database.
    ///
    /// - parameter endpoint: TargetType from Moya which specify API endpoint to be called.
    /// - returns: Observable which emits Lce with Array of a given type.
    ///
    func networkStream<T: CodableObject>(endpoint: TargetType) -> Observable<Lce<[T]>> {
        return provider.request(MultiTarget(endpoint)).asObservable().filterSuccess().map([T].self).flatMap({ (objects) -> Observable<Lce<[T]>> in
            return self.realm.rx.save(objects)
        }).catchError({ (error) in error.asServiceError() })
    }
    
    ///
    /// Generic function for observing on a specified network call.
    /// Automatically filters out API errors, map to an array, append to a given list and save to database.
    ///
    /// - parameter endpoint: TargetType from Moya which specify API endpoint to be called.
    /// - parameter list: List that will be extented with new objects.
    /// - returns: Observable which emits Lce with Array of a given type.
    ///
    func networkStreamWithAppend<T: CodableObject>(endpoint: TargetType, list: List<T>) -> Observable<Lce<[T]>> {
        return provider.request(MultiTarget(endpoint)).asObservable().filterSuccess().map([T].self).flatMap({ (objects) -> Observable<Lce<[T]>> in
            return self.realm.rx.appendToList(list, objects: objects).map({ _ in Lce<[T]>(data: objects) })
        }).catchError({ (error) in error.asServiceError() })
    }
    
}
