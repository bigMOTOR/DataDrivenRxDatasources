//
//  AnimatableControllerViewModel.swift
//  Example
//
//  Created by Dmitriy on 5/14/20.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources
import DataDrivenRxTableView

struct AnimatableControllerViewModel {
  let sections: Driver<[AnimatableCollectionSectionModel<String>]>
  let section = BehaviorRelay<[IdentifiableCollectionCellViewModel]>(value: [
    XibCollectionCellViewModel(value: "XIB"),
    ProtoTypeCollectionCellViewModel(value: "Proto"),
    ClassCollectionCellViewModel(value: "Class", onSelected: { print("Selected") })
  ])
  
  init() {
    sections = section
      .map { [AnimatableCollectionSectionModel(model: "Example section", items: $0)] }
      .asDriver(onErrorJustReturn: [])
  }
  
  func insertRow() {
    section.add(element: provideRandomCell())
  }
  
  private func provideRandomCell() -> IdentifiableCollectionCellViewModel {
    let number = "\(section.value.count + 1)"
    return [
      XibCollectionCellViewModel(value: number),
      ProtoTypeCollectionCellViewModel(value: number),
      ClassCollectionCellViewModel(value: number, onSelected: { print("onSelected") })][Int.random(in: (0...2))]
  }
}
