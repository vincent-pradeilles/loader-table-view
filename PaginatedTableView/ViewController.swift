//
//  ViewController.swift
//  PaginatedTableView
//
//  Created by Vincent PRADEILLES on 24/03/2017.
//  Copyright © 2017 Vincent PRADEILLES. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, LoaderTableViewTrait {

    @IBOutlet weak var tableView: UITableView!
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    let viewModel: ViewModel = ViewModel()
    
    lazy var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
        
        hookUpLoaderTableViewTrait()
        
        viewModel.retrieveAdditionalData()
    }
    
    func setupUI() {
        self.tableView
            .rx
            .willDisplayCell
            .asDriver()
            .drive(onNext: { [unowned self] (willDisplayCellEvent) in
                // if it's the last cell
                if willDisplayCellEvent.indexPath.row == (self.viewModel.data.value.count - 1) {
                    self.viewModel.retrieveAdditionalData()
                }
            }).addDisposableTo(disposeBag)
        
        self.tableView
            .rx
            .itemSelected
            .asDriver()
            .drive(onNext: { [unowned self] (selectedIndexPath) in
                self.tableView.deselectRow(at: selectedIndexPath, animated: true)
            }).addDisposableTo(disposeBag)
    }
    
    func bindViewModel() {
        viewModel.data
            .asDriver()
            .drive(self.tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, data, cell) -> Void in
                cell.textLabel?.text = data
            }.addDisposableTo(disposeBag)
    }
}
