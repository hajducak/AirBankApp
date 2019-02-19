//
//  TransactionCell.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var incomingOrOutcomingTransactionImageView: UIImageView!
    
    @IBOutlet weak var amountLabel: UILabel! {
        didSet {
            amountLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            amountLabel.textColor = UIColor.darkGray
        }
    }
    
    @IBOutlet weak var typeOfTransactionLabel: UILabel! {
        didSet {
            typeOfTransactionLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
            typeOfTransactionLabel.textColor = UIColor.lightGray
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
