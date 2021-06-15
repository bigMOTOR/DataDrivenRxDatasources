//
//  ReloadTableViewModel.swift
//  Example
//
//  Created by Dmitriy on 5/7/20.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import DataDrivenRxDatasources

struct ReloadTableViewModel {
  let sections: Driver<[TableSectionModel<String>]>
  let _repository: SomeRepository
  
  init(repository: SomeRepository = SomeRepository()) {
    _repository = repository
    sections = _repository.models
      .map {
        [TableSectionModel(model: "",
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
  
private func _cellViewModel(deleteAction: @escaping (SomeModel) -> Void, setDetails: @escaping () -> Void) -> (SomeModel) -> CellViewModel {
  return { model in
    switch model {
    case .xibType(let id):
      return XibCellViewModel(value: id, onDeleted: { deleteAction(model) })
    case .classType(let id):
      return ClassCellViewModel(value: id, onSelected: { print("cell selected") })
    case .protoType(let id):
      return ProtoTypeCellViewModel(value: id, onInfoTap: { print("cell info tapped") })
    case .trailingSwipeable(let replacingDetails):
      return TrailingSwipeableCellViewModel(details: replacingDetails, trailingAction: setDetails)
    }
  }
}
