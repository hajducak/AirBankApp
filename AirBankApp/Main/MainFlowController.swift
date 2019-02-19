//
//  MainFlowController.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class MainFlowController {
    
    fileprivate let navigationController: UINavigationController
    
    fileprivate let dependencies: AppDependency
    
    init(navigationController: UINavigationController, dependencies: AppDependency) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        presentTransactionsViewController()
    }
    
    func presentTransactionsViewController() {
        let transactionsNavigationController = UINavigationController()
        let flowController = TransactionsFlowController(navigationController: transactionsNavigationController, dependencies: dependencies)
        navigationController.present(transactionsNavigationController, animated: true, completion: nil)
        flowController.flowDelegate = self
        flowController.start()
    }
}

extension MainFlowController: TransactionsFlowControllerDelegate {
    
}
