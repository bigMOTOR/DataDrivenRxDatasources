//
//  CellViewModel.swift
//  
//
//  Created by Nikolay Fiantsev on 05.05.2020.
//

import UIKit

// MARK: - Base

// CellTypes as a loading type
public enum CellType {
  // directly form class
  case classType(UITableViewCell.Type)
  // from xib file
  case nibType(name: String, bundle: Bundle? = nil)
  // from storyboard
  case prototype(reuseId: String)
}

// Base protocol for viewModel. Binds viewModel to CellType. Used to register and dequeue UITableViewCell subclasses.
public protocol CellViewModel {
  var cellViewClass: CellType { get }
}

// Base protocol for UITableViewCell subclass. It [subclass] should update UI on cellModel didSet using new value.
public protocol ModelledCell {
  var cellModel: CellViewModel? { get set }
}

// MARK: - internal

// extension to handle registering and dequeueing cells using viewModel
extension CellType {
  func registerFor(table: UITableView) {
    switch self {
    case .classType(let type):
      table.register(type, forCellReuseIdentifier: identifier)
    case .nibType(let nibName, let bundle):
      table.register(UINib(nibName: nibName, bundle: bundle), forCellReuseIdentifier: identifier)
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
