//
//  AppFlowController.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class AppFlowController {
    
    fileprivate let window: UIWindow
    
    fileprivate let dependencies: AppDependency
    
    init(window: UIWindow) {
        self.window = window
        dependencies = AppDependency(transactionsService: TransactionsService())
    }
    
    func start() {
        let navController = UINavigationController()
        window.rootViewController = navController
        window.makeKeyAndVisible()
        let flowController = MainFlowController(navigationController: navController, dependencies: dependencies)
        flowController.start()
    }
}
