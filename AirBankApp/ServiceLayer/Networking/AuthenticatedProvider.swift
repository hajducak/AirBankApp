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
            return defaultEndpoint
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
        
        self.provider = MoyaProvider<MultiTarget>(endpointClosure: endpointClosure, manager: manager, plugins: plugins)
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
