//
//  SampleCellViewModel.swift
//  
//
//  Created by Nikolay Fiantsev on 07.05.2020.
//

import Foundation
@testable import DataDrivenRxTableView

struct SampleCellViewModel: Equatable {
  let name: String
}

extension SampleCellViewModel: IdentifiableCellViewModel {
  var identity: Int {
    return name.hash
  }
  
  func isEqual(to: IdentifiableCellViewModel) -> Bool {
    guard let to = to as? SampleCellViewModel else { return false }
    return name == to.name
  }
}
