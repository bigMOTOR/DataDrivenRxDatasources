//
//  AnimatableTableSectionModel.swift
//  
//
//  Created by Nikolay Fiantsev on 05.05.2020.
//

import Foundation
import RxDataSources

public struct AnimatableTableSectionModel<Section: IdentifiableType> {
  public var model: Section
  public var items: [Item]
  
  public init(model: Section, items: [IdentifiableCellViewModel]) {
    self.model = model
    self.items = items.map(AnimatableCellViewModel.init)
  }
}

extension AnimatableTableSectionModel: AnimatableSectionModelType {
  public typealias Item = AnimatableCellViewModel
  public typealias Identity = Section.Identity
  
  public var identity: Section.Identity {
    return model.identity
  }
  
  public init(original: AnimatableTableSectionModel, items: [Item]) {
    self.model = original.model
    self.items = items
  }
}
