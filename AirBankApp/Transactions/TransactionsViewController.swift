//
//  TransactionsViewController.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum TypeOfTransaction: String {
    case incoming = "INCOMING"
    case outgoing = "OUTGOING"
    
    func getImage() -> UIImage? {
        switch self {
        case .incoming:
            return UIImage(named: "incoming")
        case .outgoing:
            return UIImage(named: "outcoming")
        }
    }
    
    func getName() -> String {
         switch self {
            case .incoming:
                return  "incoming"
            case .outgoing:
                return  "outcoming"
        }
    }
}

protocol TransactionsFlowDelegate {
    func showDetailOfTransaction(currentTransaction: TransactionDetail, transaction: Transaction)
}

class TransactionsViewController: BaseViewController {
    
    fileprivate var idOfTransaction: Int?
    
    var transactions: [Transaction] = [] {
        didSet {
            transactionsTableView.reloadData()
        }
    }
    var currentTransactionDetail: TransactionDetail? {
        didSet {
            if let currentTransactionDetail = self.currentTransactionDetail, let id = self.idOfTransaction  {
                flowDelegate?.showDetailOfTransaction(currentTransaction: currentTransactionDetail, transaction: transactions[id - 1])
            }
            
        }
    }
    
    var viewModel: TransactionViewModel?
    
    var transactionDetail =  PublishSubject<Int>()
    
    //var disposeBag = DisposeBag()
    
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
        
        navigationController?.navigationBar.backgroundColor = UIColor.darkGray
        
        let attributedStirngLabel = UILabel()
        let attributedStirngText = NSMutableAttributedString(string: "Transactions", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .regular), NSAttributedString.Key.foregroundColor : UIColor.white])
        
        attributedStirngLabel.attributedText = attributedStirngText
        self.navigationItem.titleView = attributedStirngLabel
        
        transactionsTableView.delegate = self
        transactionsTableView.dataSource = self
    }
    
    override func setupViewModel() {
        super.setupViewModel()
        
        let input = TransactionViewModel.Input(nextTransactionDetail: transactionDetail)
        
        let output = self.viewModel?.transform(input: input)
        
        output?.transactionsReqest.drive(onNext: { (event) in
            if event.isLoading {
                self.view.startActivityIndicator()
            } else if let er = event.error {
                self.view.stopActivityIndicator()
                AlertHandler.showWhisper(message: "\(er.message)", type: .error, shouldHide: true)
            } else if let transactions = event.data {
                self.view.stopActivityIndicator()
                self.transactions = transactions
            }
        }).disposed(by: self.disposeBag)
        
        output?.transactionDetail.drive(onNext: { (event) in
            if event.isLoading {
                self.view.startActivityIndicator()
            } else if let er = event.error {
                self.view.stopActivityIndicator()
                AlertHandler.showWhisper(message: "\(er.message)", type: .error, shouldHide: true)
            } else if let transaction = event.data {
                self.view.stopActivityIndicator()
                self.currentTransactionDetail = transaction
            }
        }).disposed(by: self.disposeBag)
        
    }
}

extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionsTableView.dequeueReusableCell(withIdentifier: TransactionCell.nameOfClass, for: indexPath) as! TransactionCell
        
        let transaction = self.transactions[indexPath.row]
        if let typeOfTransaction = TypeOfTransaction.init(rawValue: transaction.direction), let image = typeOfTransaction.getImage() {
            cell.incomingOrOutcomingTransactionImageView.image = image
            cell.typeOfTransactionLabel.text = typeOfTransaction.getName()
        }
        cell.amountLabel.text = "\(transaction.amountInAccountCurrency)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.idOfTransaction = transactions[indexPath.row].id
        if let id = self.idOfTransaction {
            transactionDetail.onNext(id)
        }
        transactionsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}
