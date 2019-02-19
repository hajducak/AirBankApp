//
//  ViewController.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

enum MainTab: Int {
    case transaction = 1
}

protocol MainFlowDelegate: class {
    func tabBarItemDidChanged(item: UITabBarItem)
}

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var flowDelegate: MainFlowDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        flowDelegate?.tabBarItemDidChanged(item: item)
    }
    
    
}
