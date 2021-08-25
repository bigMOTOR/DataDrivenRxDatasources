//
//  UITableViewCellViewModel.swift
//  Example
//
//  Created by Mikhail Markin on 09.05.2020.
//

import Foundation
import RxDataSources
import DataDrivenRxDatasources

struct ClassCellViewModel: SelectableType {
  let value: String
  let onSelected: (() -> Void)?
}

extension ClassCellViewModel: IdentifiableCellViewModel {
  func isEqual(to: IdentifiableCellViewModel) -> Bool {
    guard let to = to as? ClassCellViewModel else { return false }
    return value == to.value
  }
  var identity: Int {
    return value.hash
  }
}
