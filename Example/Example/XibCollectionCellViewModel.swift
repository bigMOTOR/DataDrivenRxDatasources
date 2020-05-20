//
//  XibCollectionCellViewModel.swift
//  Example
//
//  Created by Dmitriy on 5/13/20.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import Foundation
import RxDataSources
import DataDrivenRxTableView

struct XibCollectionCellViewModel {
  let value: String
}

extension XibCollectionCellViewModel: IdentifiableCollectionCellViewModel {
  func isEqual(to: IdentifiableCollectionCellViewModel) -> Bool {
    guard let to = to as? XibCollectionCellViewModel else { return false }
    return value == to.value
  }
  var identity: Int {
    return value.hash
  }
}
