//
//  AnimatableViewModel.swift
//  Example
//
//  Created by Dmitriy on 5/8/20.
//

import Foundation
import RxCocoa
import RxDataSources
import DataDrivenRxDatasources

struct DiffableViewModel {
  let sections: Driver<[DiffableTableSectionModel<String>]>
  let _repository: SomeRepository
  
  init(repository: SomeRepository = SomeRepository()) {
    _repository = repository
    sections = _repository.models
      .map {
        [DiffableTableSectionModel(model: "",
                                   items: $0.map(_cellViewModel(deleteAction: repository.remove,
                                                                setDetails: { repository.newTrailingSwipeableDetails(UUID().uuidString) })))]
      }
      .asDriver(onErrorJustReturn: [])
  }
  
  func insertRow() {
    _repository.add(provideRandomCell())
  }
}

private func provideRandomCell() -> SomeModel {
  let number = UUID().uuidString
  return [
    SomeModel.xibType(number),
    SomeModel.classType(number),
    SomeModel.protoType(number),
  ][Int.random(in: (0...2))]
}

private func _cellViewModel(deleteAction: @escaping (SomeModel) -> Void, setDetails: @escaping () -> Void) -> (SomeModel) -> IdentifiableCellViewModel {
  return { model in
    switch model {
    case .xibType(let id):
      return XibCellViewModel(value: id, onDeleted: { deleteAction(model) })
    case .classType(let id):
      return ClassCellViewModel(value: id, onSelected: { print("cell selected") })
    case .protoType(let id):
      return ProtoTypeCellViewModel(value: id, onInfoTap: { print("cell info tapped") })
    case .trailingSwipeable(let id):
      return TrailingSwipeableCellViewModel(details: id, trailingAction: setDetails)
    }
  }
}


