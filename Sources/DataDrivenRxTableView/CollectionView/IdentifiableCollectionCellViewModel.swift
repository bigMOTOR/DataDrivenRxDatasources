//
//  IdentifiableCollectionCellViewModel.swift
//  
//
//  Created by Mikhail Markin on 08.05.2020.
//

import Foundation
import RxDataSources

// MARK: - IdentifiableCollectionCellViewModel

public protocol IdentifiableCollectionCellViewModel: CollectionCellViewModel {
  var identity: Int { get }
  func isEqual(to: IdentifiableCollectionCellViewModel) -> Bool
}

// MARK: - CollectionCellViewModelWrapper

protocol CollectionCellViewModelWrapper {
  var base: CollectionCellViewModel { get }
}

// MARK: - AnyCollectionCellViewModel

public struct AnyCollectionCellViewModel: CollectionCellViewModelWrapper {
  let base: CollectionCellViewModel
}

// MARK: - AnimatableCollectionCellViewModel

/// A wrapper for CollectionCellViewModel, that allows to use it with AnimatableSectionModel
public struct AnimatableCollectionCellViewModel: CollectionCellViewModelWrapper {
  var base: CollectionCellViewModel {
    return _base
  }
  
  private let _base: IdentifiableCollectionCellViewModel
  
  init(base: IdentifiableCollectionCellViewModel) {
    self._base = base
  }
}

extension AnimatableCollectionCellViewModel: IdentifiableType, Equatable {
  public typealias Identity = Int
  
  public var identity: Identity {
    return _base.identity
  }
  
  public static func ==(lhs: AnimatableCollectionCellViewModel, rhs: AnimatableCollectionCellViewModel) -> Bool {
    return lhs._base.isEqual(to: rhs._base)
  }
}
