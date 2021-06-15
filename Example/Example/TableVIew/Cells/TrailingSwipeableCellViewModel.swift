//
//  TrailingSwipeableCellViewModel.swift
//  Example
//
//  Created by Nikolay Fiantsev on 15.06.2021.
//  Copyright © 2021 Dmitriy. All rights reserved.
//

import RxDataSources
import DataDrivenRxDatasources

struct TrailingSwipeableCellViewModel: TrailingSwipeableType {
  let title: String
  let details: String
  let trailingSwipeActions: [SwipeAction]
  
  init(details: String, trailingAction: @escaping ()->Void) {
    self.title = "Swipe 👈"
    self.details = details
    self.trailingSwipeActions = [.init(image: .init(systemName: "repeat"), backgroundColor: .orange, handler: trailingAction)]
  }
}

extension TrailingSwipeableCellViewModel: IdentifiableCellViewModel {
  var identity: Int {
    return title.hash
  }
  
  func isEqual(to: IdentifiableCellViewModel) -> Bool {
    guard let to = to as? TrailingSwipeableCellViewModel else { return false }
    return title == to.title
      && details == to.details
  }
}
