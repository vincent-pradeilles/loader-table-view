//
//  LoaderTableViewTrait.swift
//  PaginatedTableView
//
//  Created by Vincent PRADEILLES on 24/03/2017.
//  Copyright © 2017 Vincent PRADEILLES. All rights reserved.
//

import UIKit
import RxSwift

protocol PaginatedDataViewModel {
    var isMoreDataAvailable: Variable<Bool> { get }
}

protocol LoaderTableViewTrait: class {
    associatedtype ViewModel: PaginatedDataViewModel
    var tableView: UITableView! { get }
    var activityIndicator: UIActivityIndicatorView { get }
    var viewModel: ViewModel { get }
    var disposeBag: DisposeBag { get }
}

extension LoaderTableViewTrait where Self: UIViewController {
    func hookUpLoaderTableViewTrait() {
        self.setupUI()
        self.bindViewModel()
    }
    
    private func setupUI() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.tableView.tableFooterView = activityIndicator
    }
    
    private func bindViewModel() {
        viewModel.isMoreDataAvailable
            .asDriver()
            .drive(onNext: { (isMoreDataAvailable) in
                self.tableView.tableFooterView = isMoreDataAvailable ? self.activityIndicator : UIView()
            }).addDisposableTo(disposeBag)
    }
}
