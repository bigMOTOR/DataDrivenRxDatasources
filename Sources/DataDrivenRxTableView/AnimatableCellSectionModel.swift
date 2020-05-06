//
//  AnimatableCellSectionModel.swift
//  
//
//  Created by Nikolay Fiantsev on 05.05.2020.
//

import Foundation
import RxDataSources

struct AnimatableCellSectionModel<Section: IdentifiableType>: AnimatableSectionModelType {
  typealias Item = AnimatableCellViewModel
  typealias Identity = Section.Identity
  
  public var model: Section
  public var items: [AnimatableCellViewModel]
  
  public init(model: Section, items: [IdentifiableCellViewModel]) {
    self.model = model
    self.items = items.map { AnimatableCellViewModel(base: $0) }
  }
  
  public var identity: Section.Identity {
    return model.identity
  }
  
  public init(original: AnimatableCellSectionModel, items: [Item]) {
    self.model = original.model
    self.items = items
  }
  
  public var hashValue: Int {
    return self.model.identity.hashValue
  }
}
