//
//  ClassCollectionCellViewModel.swift
//  Example
//
//  Created by Dmitriy on 5/14/20.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import Foundation
import RxDataSources
import DataDrivenRxDatasources

struct ClassCollectionCellViewModel: SelectableType {
  let value: String
  let onSelected: (() -> (Void))?
}

extension ClassCollectionCellViewModel: IdentifiableCollectionCellViewModel {
  func isEqual(to: IdentifiableCollectionCellViewModel) -> Bool {
    guard let to = to as? ClassCollectionCellViewModel else { return false }
    return value == to.value
  }
  
  var identity: Int {
    return value.hash
  }
}
