//
//  StaticCellViewModel.swift
//  Example
//
//  Created by Dmitriy on 5/7/20.
//

import Foundation
import RxDataSources
import DataDrivenRxDatasources

struct XibCellViewModel: DeletableType {
  let value: String
  let onDeleted: (() -> Void)?
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
