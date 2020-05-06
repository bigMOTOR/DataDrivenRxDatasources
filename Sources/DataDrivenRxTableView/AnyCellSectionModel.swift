//
//  AnyCellSectionModel.swift
//  
//
//  Created by Nikolay Fiantsev on 05.05.2020.
//

import Foundation
import RxDataSources

struct AnyCellSectionModel<Section>: SectionModelType {
  typealias Item = AnyCellViewModel
  
  public var model: Section
  public var items: [AnyCellViewModel]
  
  public init(model: Section, items: [CellViewModel]) {
    self.model = model
    self.items = items.map { AnyCellViewModel(base: $0) }
  }
  
  public init(original: AnyCellSectionModel, items: [Item]) {
    self.model = original.model
    self.items = items
  }
}
