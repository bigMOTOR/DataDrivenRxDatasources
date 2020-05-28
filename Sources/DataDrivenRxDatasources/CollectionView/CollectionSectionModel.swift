//
//  CollectionSectionModel.swift
//  
//
//  Created by Mikhail Markin on 08.05.2020.
//

import Foundation
import RxDataSources

public struct CollectionSectionModel<Section> {
  public var model: Section
  public var items: [Item]
  
  public init(model: Section, items: [CollectionCellViewModel]) {
    self.model = model
    self.items = items.map(AnyCollectionCellViewModel.init)
  }
}

extension CollectionSectionModel: SectionModelType {
  typealias Identity = Section
  public typealias Item = AnyCollectionCellViewModel
  
  public init(original: CollectionSectionModel, items: [Item]) {
    self.model = original.model
    self.items = items
  }
}

