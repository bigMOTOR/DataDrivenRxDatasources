//
//  HeaderFooterType.swift
//  
//
//  Created by Mikhail Markin on 25.08.2021.
//

import UIKit

// MARK: - Base

// CellTypes as a loading type
public enum HeaderFooterType {
  // directly form class
  case classType(UITableViewHeaderFooterView.Type)
  // from xib file
  case nibType(name: String, bundle: Bundle? = nil)
  // from storyboard
  case prototype(reuseId: String)
}

// Base protocol for viewModel. Binds viewModel to CellType. Used to register and dequeue UITableViewCell subclasses.
public protocol HeaderFooterViewModel {
  var headerFooterViewClass: HeaderFooterType { get }
}

// Base protocol for UITableViewCell subclass. It [subclass] should update UI on cellModel didSet using new value.
public protocol ModelledHeaderFooterView {
  var headerFooterModel: HeaderFooterViewModel? { get set }
}

// MARK: - internal

// extension to handle registering and dequeueing cells using viewModel
extension HeaderFooterType {
  func registerFor(table: UITableView) {
    switch self {
    case .classType(let type):
      table.register(type, forHeaderFooterViewReuseIdentifier: identifier)
    case .nibType(let nibName, let bundle):
      table.register(UINib(nibName: nibName, bundle: bundle), forHeaderFooterViewReuseIdentifier: identifier)
    case .prototype:
      break // Must be registered in Storyboard
    }
  }
  
  var identifier: String {
    switch self {
    case .classType(let type):
      return "\(type)"
    case .nibType(let nibName, _):
      return nibName
    case .prototype(let id):
      return id
    }
  }
}
