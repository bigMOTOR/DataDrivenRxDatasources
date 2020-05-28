//
//  CollectionCellViewModel.swift
//  
//
//  Created by Mikhail Markin on 07.05.2020.
//

import UIKit

// MARK: - Base

// CollectionCellType as a loading type
public enum CollectionCellType {
  // directly form class
  case classType(UICollectionViewCell.Type)
  // from xib file
  case nibType(name: String)
  // from storyboard
  case prototype(reuseId: String)
}

// Base protocol for viewModel. Binds viewModel to CollectionCellType. Used to register and dequeue UICollectionViewCell subclasses.
public protocol CollectionCellViewModel {
  var cellViewClass: CollectionCellType { get }
}

// Base protocol for UICollectionViewCell subclass. It [subclass] should update UI on cellModel didSet using new value.
public protocol ModelledCollectionCell {
  var cellModel: CollectionCellViewModel? { get set }
}

// MARK: - internal

// extension to handle registering and dequeueing cells using viewModel
extension CollectionCellType {
  func registerFor(collection: UICollectionView) {
    switch self {
    case .classType(let type):
      collection.register(type, forCellWithReuseIdentifier: identifier)
    case .nibType(let nibName):
      collection.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: identifier)
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
