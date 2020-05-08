//
//  StaticCellViewModel.swift
//  Example
//
//  Created by Dmitriy on 5/7/20.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import Foundation
import RxDataSources

struct XibCellViewModel {
  let value: String
}

extension XibCellViewModel: IdentifiableType {
  var identity: Int {
    return value.hash
  }
}

