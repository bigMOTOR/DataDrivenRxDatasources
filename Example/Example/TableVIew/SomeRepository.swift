//
//  SomeRepository.swift
//  
//
//  Created by Mikhail Markin on 29.07.2020.
//

import Foundation
import RxSwift
import RxCocoa

enum SomeModel {
  case xibType(String)
  case classType(String)
  case protoType(String)
  
  var id: String {
    switch self {
    case .xibType(let id):
      return id
    case .classType(let id):
      return id
    case .protoType(let id):
      return id
    }
  }
}

struct SomeRepository {
  private let _models = BehaviorRelay<[SomeModel]>(value: [
    .xibType(UUID().uuidString),
    .classType(UUID().uuidString),
    .protoType(UUID().uuidString),
  ])
  
  var models: Observable<[SomeModel]> {
    return _models.asObservable()
  }
  
  func add(_ model: SomeModel) {
    _models.add(element: model)
  }
  
  func remove(_ model: SomeModel) {
    _models.accept(_models.value.filter { $0.id != model.id })
  }
}
