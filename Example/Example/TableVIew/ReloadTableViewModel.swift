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
import DataDrivenRxTableView

struct ReloadTableViewModel {
  let sections: Driver<[TableSectionModel<String>]>
  let section = BehaviorRelay<[CellViewModel]>(value: [
      XibCellViewModel(value: "1"),
      ClassCellViewModel(value: "2", onSelected: { print("cell selected") }),
      ProtoTypeCellViewModel(value: "3", onInfoTap: { print("cell info tapped") }),
    ])
  
  init() {
    sections = section
      .map { [TableSectionModel(model: "", items: $0)] }
      .asDriver(onErrorJustReturn: [])
  }
  
  func insertRow() {
    section.accept(section.value + [XibCellViewModel(value: "New row")])
  }
}
