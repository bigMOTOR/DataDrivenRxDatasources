//
//  BehaviourRelayExtension.swift
//  Example
//
//  Created by Dmitriy on 5/14/20.
//

import RxCocoa

extension BehaviorRelay where Element: RangeReplaceableCollection {
  func add(element: Element.Element) {
    var array = self.value
    array.append(element)
    self.accept(array)
  }
}
