//
//  TableSectionModel.swift
//  
//
//  Created by Nikolay Fiantsev on 05.05.2020.
//

import Foundation
import RxDataSources

public struct TableSectionModel<Section> {
  public var model: Section
  public var items: [Item]
  
  public init(model: Section, items: [CellViewModel]) {
    self.model = model
    self.items = items.map(AnyCellViewModel.init)
  }
}

extension TableSectionModel: SectionModelType {
  typealias Identity = Section
  public typealias Item = AnyCellViewModel
  
  public init(original: TableSectionModel, items: [Item]) {
    self.model = original.model
    self.items = items
  }
}
