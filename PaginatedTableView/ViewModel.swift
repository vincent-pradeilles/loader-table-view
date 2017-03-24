//
//  ViewModel.swift
//  PaginatedTableView
//
//  Created by Vincent PRADEILLES on 24/03/2017.
//  Copyright © 2017 Vincent PRADEILLES. All rights reserved.
//

import Foundation
import RxSwift

class ViewModel: PaginatedDataViewModel {
    let data = Variable<[String]>([])
    let isMoreDataAvailable = Variable<Bool>(true)
    
    func retrieveAdditionalData() {
        if isMoreDataAvailable.value {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.data.value += ["foo", "bar"]
                self.isMoreDataAvailable.value = (self.data.value.count < 20)
            }
        }
    }
}
