//
//  AnimatableTableSectionModel.swift
//  
//
//  Created by Mikhail Markin on 23.08.2021.
//

import Foundation
import RxDataSources

@available(iOS 13.0, *)
public struct DiffableTableSectionModel<Section: Hashable> {
  public var model: Section
  public var items: [DiffableCellViewModel]
  
  public init(model: Section, items: [IdentifiableCellViewModel]) {
    self.model = model
    self.items = items.map(DiffableCellViewModel.init)
  }
}

// TODO: get rid of an extension once RxDataSources is removed
@available(iOS 13.0, *)
extension DiffableTableSectionModel: SectionModelType {
  public typealias Item = DiffableCellViewModel
  
  public init(original: DiffableTableSectionModel, items: [Item]) {
    self.model = original.model
    self.items = items
  }
}
