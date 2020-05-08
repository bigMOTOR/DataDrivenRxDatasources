//
//  ReloadTableViewModel.swift
//  Example
//
//  Created by Dmitriy on 5/7/20.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import Foundation
import RxCocoa
import DataDrivenRxTableView

struct ReloadTableViewModel {
  let sections: Driver<[TableSectionModel<String>]>
  init() {
     self.sections = .just([
      TableSectionModel(model:"", items: [
        XibCellViewModel(value: "1"),
        ClassCellViewModel(value: "2", onSelected: { print("cell selected") }),
        ProtoTypeCellViewModel(value: "3", onInfoTap: { print("cell info tapped") }),
      ])
     ])
   }
}
