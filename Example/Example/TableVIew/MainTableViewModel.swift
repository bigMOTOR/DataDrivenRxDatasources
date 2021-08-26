//
//  MainTableViewModel.swift
//  Example
//
//  Created by Mikhail Markin on 09.05.2020.
//

import Foundation
import RxSwift
import RxCocoa
import DataDrivenRxDatasources

struct MainTableViewModel {
  let sections: Driver<[TableSectionModel<String>]>
  
  enum Action {
    case toReloadExamples
    case toAnimatableExamples
    case toDiffableExamples
    case toHeadersAndFooters
  }
  
  let actions: Driver<Action>
  
  init() {
    let _actionSubjet = PublishSubject<Action>()
    
    self.actions = _actionSubjet.asDriver(onErrorDriveWith: .empty())
    
    self.sections = .just([TableSectionModel(model:"", items: [
      ClassCellViewModel(value: "Reload example", onSelected: { _actionSubjet.onNext(.toReloadExamples) }),
      ClassCellViewModel(value: "Animated example", onSelected: { _actionSubjet.onNext(.toAnimatableExamples) }),
      ClassCellViewModel(value: "Diffable example", onSelected: { _actionSubjet.onNext(.toDiffableExamples) }),
      ClassCellViewModel(value: "Headers and Footers example", onSelected: { _actionSubjet.onNext(.toHeadersAndFooters) }),
    ])])
  }
}

