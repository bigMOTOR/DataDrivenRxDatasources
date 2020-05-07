//
//  ModelledCell.swift
//  
//
//  Created by Nikolay Fiantsev on 05.05.2020.
//

import UIKit

public protocol ModelledCell {
  var cellModel: CellViewModel? { get set }
}

public protocol CellViewModel {
  var cellViewClass: CellType { get }
}

public protocol Selectable {
  var onSelected:(() -> Void)? { get }
}

public protocol InfoTappable {
  var onInfoTap:(() -> Void)? { get }
}

public typealias CellViewModelWithActions = Selectable & InfoTappable

public protocol Sizable {
  var estimatedHeight: CGFloat { get }
}

extension Sizable {
  var estimatedHeight: CGFloat {
     return 44.0
  }
}

public enum CellType {
  case classType(UITableViewCell.Type)
  case nibType(name: String)
  case prototype(reuseId: String)
}

extension CellType {
  func registerFor(table: UITableView) {
    switch self {
    case .classType(let type):
      table.register(type, forCellReuseIdentifier: identifier)
    case .nibType(let nibName):
      table.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: identifier)
    case .prototype:
      break // Must be registered in Storyboard
    }
  }
  
  var identifier: String {
    switch self {
    case .classType(let type):
      return "\(type)"
    case .nibType(let nibName):
      return nibName
    case .prototype(let id):
      return id
    }
  }
}

// MARK: - ModelledCollectionCell

protocol ModelledCollectionCell {
  var cellModel: CollectionCellViewModel? { get set }
}

protocol CollectionCellViewModel {
  var cellViewClass: CollectionCellType { get }
}

enum CollectionCellType {
  case classType(UICollectionViewCell.Type)
  case nibType(name: String)
}

extension CollectionCellType {
  func registerFor(collection: UICollectionView) {
    switch self {
    case .classType(let type):
      collection.register(type, forCellWithReuseIdentifier: identifier)
    case .nibType(let nibName):
      collection.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
  }
  
  var identifier: String {
    switch self {
    case .classType(let type):
      return "\(type)"
    case .nibType(let nibName):
      return nibName
    }
  }
}

