//
//  TransactionsViewController.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

enum TypeOfTransaction {
    case incoming
    case outcoming
    
    private func getImage() -> UIImage? {
        switch self {
        case .incoming:
            return UIImage(named: "incoming")
        case .outcoming:
            return UIImage(named: "outcoming")
        }
    }
}

protocol TransactionsFlowDelegate {
    func showDetailOfTransaction()
}

class TransactionsViewController: BaseViewController {
    
    @IBOutlet weak var transactionsTableView: UITableView! {
        didSet {
            let cellNib = UINib(nibName: TransactionCell.nameOfClass, bundle: nil)
            transactionsTableView.register(cellNib, forCellReuseIdentifier: TransactionCell.nameOfClass)
        }
    }
    
    var flowDelegate: TransactionsFlowDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setupViewAppearance() {
        super.setupViewAppearance()
        
        let attributedStirngLabel = UILabel()
        let attributedStirngText = NSMutableAttributedString(string: "Transactions", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        
        attributedStirngLabel.attributedText = attributedStirngText
        self.navigationItem.titleView = attributedStirngLabel
        
        transactionsTableView.delegate = self
        transactionsTableView.dataSource = self
    }
}

extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionsTableView.dequeueReusableCell(withIdentifier: TransactionCell.nameOfClass, for: indexPath) as! TransactionCell
        cell.amountLabel.text = "100 Kč"
        cell.typeOfTransactionLabel.text = "incoming"
        cell.incomingOrOutcomingTransactionImageView.image = UIImage(named: "incoming")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        flowDelegate?.showDetailOfTransaction()
        transactionsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}
