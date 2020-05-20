//
//  StaticCellViewModel.swift
//  Example
//
//  Created by Dmitriy on 5/7/20.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import Foundation
import RxDataSources
import DataDrivenRxTableView

struct XibCellViewModel {
  let value: String
}

extension XibCellViewModel: IdentifiableCellViewModel {
  var identity: Int {
    return value.hash
  }
  func isEqual(to: IdentifiableCellViewModel) -> Bool {
    guard let to = to as? XibCellViewModel else { return false }
    return value == to.value
  }
}
