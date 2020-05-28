//
//  AnimatableCollectionSectionModel.swift
//  
//
//  Created by Mikhail Markin on 08.05.2020.
//

import Foundation
import RxDataSources

public struct AnimatableCollectionSectionModel<Section: IdentifiableType> {
  public var model: Section
  public var items: [Item]
  
  public init(model: Section, items: [IdentifiableCollectionCellViewModel]) {
    self.model = model
    self.items = items.map(AnimatableCollectionCellViewModel.init)
  }
}

extension AnimatableCollectionSectionModel: AnimatableSectionModelType {
  public typealias Item = AnimatableCollectionCellViewModel
  public typealias Identity = Section.Identity
  
  public var identity: Section.Identity {
    return model.identity
  }
  
  public init(original: AnimatableCollectionSectionModel, items: [Item]) {
    self.model = original.model
    self.items = items
  }
}

