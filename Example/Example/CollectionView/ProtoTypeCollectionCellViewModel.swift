//
//  ProtoTypeCollectionCellViewModel.swift
//  Example
//
//  Created by Dmitriy on 5/14/20.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import Foundation
import RxDataSources
import DataDrivenRxDatasources

struct ProtoTypeCollectionCellViewModel {
  let value: String
}

extension ProtoTypeCollectionCellViewModel: IdentifiableCollectionCellViewModel {
  func isEqual(to: IdentifiableCollectionCellViewModel) -> Bool {
    guard let to = to as? ProtoTypeCollectionCellViewModel else { return false }
    return value == to.value
  }
  var identity: Int {
    return value.hash
  }
}
