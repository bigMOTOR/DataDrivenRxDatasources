//
//  StaticCellsViewModel.swift
//  Example
//
//  Created by Dmitriy on 5/7/20.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources
import DataDrivenRxTableView

struct StaticCellsViewModel {
  let sections: Driver<[SectionModel<String, CellViewModel>]>
  init() {
     self.sections = Driver<[SectionModel<String, CellViewModel>]>.just([SectionModel(model:"", items: [StaticCellViewModel(value: "1")])])
   }
}
