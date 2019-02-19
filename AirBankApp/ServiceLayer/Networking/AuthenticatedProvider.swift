//
//  AuthenticatedProvider.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import RxSwift
import AWSCognitoIdentityProvider

// Custom Moya provider
// Idea taken from: https://github.com/Moya/Moya/blob/master/docs/Examples/ComposingProvider.md

final class AuthenticatedProvider<MultiTarget> where MultiTarget: Moya.TargetType {
    
    private let provider: MoyaProvider<MultiTarget>
    
    init(headers: [String : String] = [:], parameters: [String : Any] = [:]) {
        
        let endpointClosure = { (target: MultiTarget) -> Endpoint in
            
            // add custom headers and parameters
            var defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            defaultEndpoint = defaultEndpoint.adding(newHTTPHeaderFields: headers)
            if parameters.count > 0 {
                defaultEndpoint = defaultEndpoint.replacing(task: .requestParameters(parameters: parameters, encoding: URLEncoding.default))
            }
            
            // add service headers
            defaultEndpoint = defaultEndpoint.adding(newHTTPHeaderFields: ["Client-Type": "ios"])
            defaultEndpoint = defaultEndpoint.adding(newHTTPHeaderFields: ["Client-App": "\(Bundle.main.bundleIdentifier!)[\(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)]"])
            defaultEndpoint = defaultEndpoint.adding(newHTTPHeaderFields: ["Client-API": "\(NetworkingConstants.apiVersion)"])
            defaultEndpoint = defaultEndpoint.adding(newHTTPHeaderFields: ["Client-OS": UIDevice.current.systemVersion])
            defaultEndpoint = defaultEndpoint.adding(newHTTPHeaderFields: ["Client-HW": UIDevice.current.identifierForVendor!.uuidString])
            
            return defaultEndpoint
        }
        
        let requestClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider.RequestResultClosure) in
            do {
                var request = try endpoint.urlRequest()
                
                // retrieve user session and sign request with access token if available
                let userPool = AWSCognitoIdentityUserPool(forKey: NetworkingConstants.cognitoUserPoolsSignInProviderKey)
                userPool.currentUser()?.getSession().continueWith(block: { (task) -> Void in
                    if let accessToken = task.result?.idToken?.tokenString {
                        request.addValue(accessToken, forHTTPHeaderField: "Authorization")
                        done(.success(request))
                    } else if let error = task.error {
                        print("Auth failed -> \(error)")
                        print(request.hashValue)
                        done(.success(request))
                    } else {
                        done(.success(request))
                    }
                })
                
            } catch let error as NSError {
                print(error)
                return
            }
        }
        
        // configure manager
        let configuration = URLSessionConfiguration.default
        let manager = Alamofire.SessionManager(configuration: configuration)
        
        // configure plugins
        var plugins: [PluginType] = []
        //plugins.append(CustomNetworkActivityPlugin())
        #if DEBUG
        plugins.append(NetworkLoggerPlugin(verbose: true, cURL: true, responseDataFormatter: { (_ data: Data) -> Data in
            do {
                let dataAsJSON = try JSONSerialization.jsonObject(with: data)
                let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
                return prettyData
            } catch {
                return data // fallback to original data if it can't be serialized.
            }
        }))
        #endif
        
        self.provider = MoyaProvider<MultiTarget>(endpointClosure: endpointClosure, requestClosure: requestClosure, manager: manager, plugins: plugins)
    }
    
    func request(_ target: MultiTarget) -> Single<Moya.Response> {
        let actualRequest = provider.rx.request(target).flatMap { (response) -> PrimitiveSequence<SingleTrait, Response> in
            if response.statusCode == 401 {
                // TODO: do something clever
                return Single.just(response)
            } else {
                return Single.just(response)
            }
        }
        return actualRequest
    }
    
}

