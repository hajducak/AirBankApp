//
//  TransactionDetailViewController.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

protocol TransactionDetailFlowDelegate {
    
}

class TransactionDetailViewController: BaseViewController {
    
    @IBOutlet weak var incomingOrOutcomingImageView: UIImageView!

    @IBOutlet weak var amountLabel: UILabel!{
        didSet {
            amountLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            amountLabel.textColor = UIColor.darkGray
        }
    }
    
    @IBOutlet weak var typeOfTraLabel: UILabel! {
        didSet {
            typeOfTraLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
            typeOfTraLabel.textColor = UIColor.lightGray
        }
    }
    
    @IBOutlet weak var accuntNumberLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var bankCodeLabel: UILabel!
    
    @IBOutlet var detailInputLabels: [UILabel]! {
        didSet {
            for label in detailInputLabels {
                label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
                label.textColor = UIColor.darkGray
            }
        }
    }
    
    @IBOutlet var detailLables: [UILabel]! {
        didSet {
            for label in detailLables {
                label.font = UIFont.systemFont(ofSize: 15, weight: .light)
                label.textColor = UIColor.lightGray
            }
        }
    }
    
    var flowDelegate: TransactionDetailFlowDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupViewAppearance() {
        super.setupViewAppearance()
        
        
        // TEST CODE //
        amountLabel.text = "100 Kč"
        typeOfTraLabel.text = "incoing"
        accuntNumberLabel.text = "111"
        accountNameLabel.text = "BU"
        bankCodeLabel.text = "3030"
        incomingOrOutcomingImageView.image = UIImage(named: "incoming")
        // TEST CODE //
        
        let attributedStirngLabel = UILabel()
        let attributedStirngText = NSMutableAttributedString(string: "Detail", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        
        attributedStirngLabel.attributedText = attributedStirngText
        self.navigationItem.titleView = attributedStirngLabel
        
    }

}





