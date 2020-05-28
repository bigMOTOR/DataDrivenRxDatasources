//
//  ProtoTypeCellViewModel.swift
//  Example
//
//  Created by Mikhail Markin on 09.05.2020.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import Foundation
import RxDataSources
import DataDrivenRxDatasources

struct ProtoTypeCellViewModel: InfoTappableType {
  let value: String
  let onInfoTap: (() -> Void)?
}

extension ProtoTypeCellViewModel: IdentifiableCellViewModel {
  var identity: Int {
    return value.hash
  }
  func isEqual(to: IdentifiableCellViewModel) -> Bool {
    guard let to = to as? ProtoTypeCellViewModel else { return false }
    return value == to.value
  }
}

