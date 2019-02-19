//
//  TransactionsFlowController.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
protocol TransactionsFlowControllerDelegate: class {
    
}

class TransactionsFlowController {
    
    var flowDelegate: TransactionsFlowControllerDelegate?
    
    fileprivate let navigationController: UINavigationController
    
    fileprivate let dependencies: AppDependency
    
    init(navigationController: UINavigationController, dependencies: AppDependency) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let transactionsStoryboard = StoryboardScene.Transactions.initialScene.instantiate()
        transactionsStoryboard.flowDelegate = self
        navigationController.viewControllers = [transactionsStoryboard]
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.lightGray
    }
    
}

extension TransactionsFlowController: TransactionsFlowDelegate {
    
}
