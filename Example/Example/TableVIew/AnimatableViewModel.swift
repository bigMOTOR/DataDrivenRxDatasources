//
//  AnimatableViewModel.swift
//  Example
//
//  Created by Dmitriy on 5/8/20.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources
import DataDrivenRxDatasources

struct AnimatableViewModel {

  let sections: Driver<[AnimatableTableSectionModel<String>]>
  let section = BehaviorRelay<[IdentifiableCellViewModel]>(value: [
    XibCellViewModel(value: "1"),
    ClassCellViewModel(value: "2", onSelected: { print("cell selected") }),
    ProtoTypeCellViewModel(value: "3", onInfoTap: { print("cell info tapped") }),
  ])
  
  init() {
    sections = section
      .map { [AnimatableTableSectionModel(model: "", items: $0)] }
      .asDriver(onErrorJustReturn: [])
  }
  
  func insertRow() {
    section.add(element: provideRandomCell())
  }
  
  private func provideRandomCell() -> IdentifiableCellViewModel {
    let number = "\(section.value.count + 1)"
    return [XibCellViewModel(value: number),
            ClassCellViewModel(value: number, onSelected: { print("cell selected") }),
            ProtoTypeCellViewModel(value: number, onInfoTap: { print("cell info tapped") })][Int.random(in: (0...2))]
  }
}
