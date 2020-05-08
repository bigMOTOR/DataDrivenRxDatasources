//
//  StaticCellViewModel.swift
//  Example
//
//  Created by Dmitriy on 5/7/20.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import Foundation
import RxDataSources

struct StaticCellViewModel {
  let value: String
}

extension StaticCellViewModel: IdentifiableType {
  var identity: Int {
    return value.hash
  }
}

