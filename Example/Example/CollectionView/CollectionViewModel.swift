//
//  CollectionViewModel.swift
//  Example
//
//  Created by Dmitriy on 5/13/20.
//

import Foundation
import RxCocoa
import DataDrivenRxDatasources

struct CollectionViewModel {
  let sections: Driver<[CollectionSectionModel<String>]>
  let section = BehaviorRelay<[CollectionCellViewModel]>(value: [
    XibCollectionCellViewModel(value: "XIB"),
    ProtoTypeCollectionCellViewModel(value: "Proto"),
    ClassCollectionCellViewModel(value: "Class", onSelected: { print("Selected") })
  ])
  
  init() {
    sections = section
      .map { [CollectionSectionModel(model: "Example section", items: $0)] }
      .asDriver(onErrorJustReturn: [])
  }
  
  func insertRow() {
    section.add(element: provideRandomCell())
  }
  
  private func provideRandomCell() -> CollectionCellViewModel {
    let number = "\(section.value.count + 1)"
    return [
      XibCollectionCellViewModel(value: number),
      ProtoTypeCollectionCellViewModel(value: number),
      ClassCollectionCellViewModel(value: number, onSelected: { print("onSelected") })][Int.random(in: (0...2))]
  }
}
