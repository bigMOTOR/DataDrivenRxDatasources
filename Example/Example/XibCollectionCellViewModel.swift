//
//  XibCollectionCellViewModel.swift
//  Example
//
//  Created by Dmitriy on 5/13/20.
//

import Foundation
import RxDataSources
import DataDrivenRxDatasources

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
