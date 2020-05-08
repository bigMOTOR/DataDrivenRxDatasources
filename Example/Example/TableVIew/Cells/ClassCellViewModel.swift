//
//  UITableViewCellViewModel.swift
//  Example
//
//  Created by Mikhail Markin on 09.05.2020.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import Foundation
import RxDataSources
import DataDrivenRxTableView

struct ClassCellViewModel: SelectableType {
  let value: String
  let onSelected: (() -> Void)?
}

extension ClassCellViewModel: IdentifiableType {
  var identity: Int {
    return value.hash
  }
}
