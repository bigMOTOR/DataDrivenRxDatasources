//
//  ProtoTypeCellViewModel.swift
//  Example
//
//  Created by Mikhail Markin on 09.05.2020.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import Foundation
import RxDataSources
import DataDrivenRxTableView

struct ProtoTypeCellViewModel: InfoTappableType {
  let value: String
  let onInfoTap: (() -> Void)?
}

extension ProtoTypeCellViewModel: IdentifiableType {
  var identity: Int {
    return value.hash
  }
}
