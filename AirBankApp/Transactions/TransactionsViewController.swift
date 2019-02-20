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
    case all = "ALL"
    
    func getImage() -> UIImage? {
        switch self {
        case .incoming:
            return UIImage(named: "incoming")
        case .outgoing:
            return UIImage(named: "outcoming")
        case .all:
            return nil
        }
    }
    
    func getName() -> String {
         switch self {
            case .incoming:
                return "incoming"
            case .outgoing:
                return "outgoig"
            case .all:
                return "all"
        }
    }
}

protocol TransactionsFlowDelegate {
    func showDetailOfTransaction(currentTransaction: TransactionDetail, transaction: Transaction)
}

class TransactionsViewController: BaseViewController {
    
    let transactionTypes = ["INCOMING","OUTGOING", "ALL"]
    
    var curretnTypeToFilter: TypeOfTransaction?
    
    private func filter() {
        if let type = curretnTypeToFilter {
            switch type {
            case .all:
                self.filteredTransactions = self.transactions
            default:
                var transactionToFiltred: [Transaction] = []
                for transaction in transactions {
                    if transaction.direction == curretnTypeToFilter?.rawValue {
                        transactionToFiltred.append(transaction)
                    }
                }
                self.filteredTransactions = transactionToFiltred
            }
        }
        
    }
    
    fileprivate var idOfTransaction: Int?
    
    var filteredTransactions: [Transaction] = [] {
        didSet {
            transactionsTableView?.reloadData()
            
        }
    }
    
    var transactions: [Transaction] = [] {
        didSet {
            filteredTransactions = transactions
            transactionsTableView?.reloadData()
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
    
    @IBOutlet weak var transactionPickerView: PickerViewTextField! {
        didSet {
            transactionPickerView.updateDelegate = self
        }
    }
    @IBOutlet weak var transactionsTableView: UITableView! {
        didSet {
            let cellNib = UINib(nibName: TransactionCell.nameOfClass, bundle: nil)
            transactionsTableView.register(cellNib, forCellReuseIdentifier: TransactionCell.nameOfClass)
        }
    }
    
    @IBOutlet weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = UIColor.lightGray
            
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
        
        navigationController?.navigationBar.barTintColor = UIColor.darkGray
        
        let attributedStirngLabel = UILabel()
        let attributedStirngText = NSMutableAttributedString(string: "Transactions", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .regular), NSAttributedString.Key.foregroundColor : UIColor.white])
        
        attributedStirngLabel.attributedText = attributedStirngText
        self.navigationItem.titleView = attributedStirngLabel
        
        transactionsTableView.delegate = self
        transactionsTableView.dataSource = self
        
        transactionPickerView.pickerView.dataSource = self
        transactionPickerView.pickerView.delegate = self
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionsTableView.dequeueReusableCell(withIdentifier: TransactionCell.nameOfClass, for: indexPath) as! TransactionCell
        
        let transaction = self.filteredTransactions[indexPath.row]
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
        self.idOfTransaction = filteredTransactions[indexPath.row].id
        if let id = self.idOfTransaction {
            transactionDetail.onNext(id)
        }
        transactionsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.curretnTypeToFilter?.getName()
    }

}


extension TransactionsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return transactionTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return TypeOfTransaction.init(rawValue: self.transactionTypes[row])?.getName()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.curretnTypeToFilter = TypeOfTransaction.init(rawValue: self.transactionTypes[row])
    }
    
}

extension TransactionsViewController: UpdateSettingsDelegate {
    func didTouchDone() {
        filter()
    }
}


