//
//  CollectionnTableViewModel.swift
//  Example
//
//  Created by Dmitriy on 5/18/20.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import DataDrivenRxTableView

struct CollectionnTableViewModel {
  let sections: Driver<[TableSectionModel<String>]>
  
  enum Action {
    case toCollectionReloadExamples
    case toCollectionAnimatableExamples
  }
  
  let actions: Driver<Action>
  
  init() {
    let _actionSubjet = PublishSubject<Action>()
    self.actions = _actionSubjet.asDriver(onErrorDriveWith: .empty())
    self.sections = .just([TableSectionModel(model:"", items: [
      ClassCellViewModel(value: "Reload example", onSelected: { _actionSubjet.onNext(.toCollectionReloadExamples) }),
      ClassCellViewModel(value: "Animated example", onSelected: { _actionSubjet.onNext(.toCollectionAnimatableExamples) }),
    ])])
  }
}

