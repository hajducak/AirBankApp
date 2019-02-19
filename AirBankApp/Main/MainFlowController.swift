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
    
    //fileprivate var main: MainTabBarController?
    
    fileprivate let dependencies: AppDependency
    
    init(navigationController: UINavigationController, dependencies: AppDependency) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let transactionsNavigationController = UINavigationController()
        let flowController = TransactionsFlowController(navigationController: transactionsNavigationController, dependencies: dependencies)
        navigationController.present(transactionsNavigationController, animated: true, completion: nil)
        flowController.flowDelegate = self
        flowController.start()
    }
    
}

extension MainFlowController: TransactionsFlowControllerDelegate {
    
}

extension MainFlowController: MainFlowDelegate {
    func tabBarItemDidChanged(item: UITabBarItem) {
//        if let subviews = main?.view.subviews {
//            for view in subviews {
//                if view.tag == item.tag {
//                    view.isHidden = false
//                } else if view.tag == 1 || view.tag == 2 || view.tag == 3 || view.tag == 4 {
//                    view.isHidden = true
//                }
//            }
//        }
    }
}
