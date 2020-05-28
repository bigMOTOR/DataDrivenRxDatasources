//
//  SampleCollectionCellViewModel.swift
//  
//
//  Created by Mikhail Markin on 07.05.2020.
//

import Foundation
@testable import DataDrivenRxDatasources

struct SampleCollectionCellViewModel: Equatable {
  let name: String
}

extension SampleCollectionCellViewModel: IdentifiableCollectionCellViewModel {
  var identity: Int {
    return name.hash
  }
  
  func isEqual(to: IdentifiableCollectionCellViewModel) -> Bool {
    guard let to = to as? SampleCollectionCellViewModel else { return false }
    return name == to.name
  }
}
