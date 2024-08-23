//
//  IdentifiableCellViewModel.swift
//  
//
//  Created by Nikolay Fiantsev on 05.05.2020.
//

import Foundation
import RxDataSources

// MARK: - IdentifiableCellViewModel

/// A wrapper to deal with PATs like IdentifiableType and Hashable
public protocol IdentifiableCellViewModel: CellViewModel {
  var identity: Int { get }
  func isEqual(to: IdentifiableCellViewModel) -> Bool
}

// MARK: - CellViewModelWrapper

protocol CellViewModelWrapper {
  var base: CellViewModel { get }
}

// MARK: - AnyCellViewModel

public struct AnyCellViewModel: CellViewModelWrapper {
  let base: CellViewModel
  
  public init(base: CellViewModel) {
    self.base = base
  }
}

// MARK: - AnimatableCellViewModel

/// A wrapper for CellViewModel, that allows to use it with AnimatableSectionModel 
public struct AnimatableCellViewModel: CellViewModelWrapper {
  public var base: CellViewModel {
    return _base
  }
  
  private let _base: IdentifiableCellViewModel
  
  public init(base: IdentifiableCellViewModel) {
    self._base = base
  }
}

extension AnimatableCellViewModel: IdentifiableType, Equatable {
  public typealias Identity = Int
  
  public var identity: Identity {
    return _base.identity
  }
  
  public static func ==(lhs: AnimatableCellViewModel, rhs: AnimatableCellViewModel) -> Bool {
    return lhs._base.isEqual(to: rhs._base)
  }
}

// MARK: - DiffableCellViewModel

/// A wrapper for CellViewModel, that allows to use it with DiffableSectionModel
@available(iOS 13.0, *)
public struct DiffableCellViewModel: CellViewModelWrapper {
  var base: CellViewModel {
    return _base
  }
  
  private let _base: IdentifiableCellViewModel
  
  init(base: IdentifiableCellViewModel) {
    self._base = base
  }
}

@available(iOS 13.0, *)
extension DiffableCellViewModel: Hashable {
  public func hash(into hasher: inout Hasher) {
    _base.identity.hash(into: &hasher)
  }
  
  public static func ==(lhs: DiffableCellViewModel, rhs: DiffableCellViewModel) -> Bool {
    return lhs._base.isEqual(to: rhs._base)
  }
}
