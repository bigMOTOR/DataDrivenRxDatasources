//
//  CellViewModelWrapper.swift
//  
//
//  Created by Nikolay Fiantsev on 05.05.2020.
//

import Foundation
import RxDataSources

protocol CellViewModelWrapper {
  var base: CellViewModel { get }
}

// MARK: - AnyCellViewModel

struct AnyCellViewModel: CellViewModelWrapper {
  let base: CellViewModel
}


// MARK: - AnimatableCellViewModel

/// A wrapper for CellViewModel, that allows to use it with AnimatableSectionModel
struct AnimatableCellViewModel: CellViewModelWrapper {
  var base: CellViewModel {
    return _base
  }
  
  private let _base: IdentifiableCellViewModel
  init(base: IdentifiableCellViewModel) {
    self._base = base
  }
}

extension AnimatableCellViewModel: IdentifiableType, Equatable {
  typealias Identity = Int
  
  var identity: Identity {
    return _base.identity
  }
  
  static func ==(lhs: AnimatableCellViewModel, rhs: AnimatableCellViewModel) -> Bool {
    return lhs._base.isEqual(to: rhs._base)
  }
}

extension IdentifiableCellViewModel {
  var animatable: AnimatableCellViewModel {
    return AnimatableCellViewModel(base: self)
  }
}

// MARK: - IdentifiableCellViewModel

protocol IdentifiableCellViewModel: CellViewModel {
  var identity: Int { get }
  func isEqual(to: IdentifiableCellViewModel) -> Bool
}
