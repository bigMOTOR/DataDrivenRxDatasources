//
//  XibCollectionViewCell.swift
//  Example
//
//  Created by Dmitriy on 5/13/20.
//

import UIKit
import DataDrivenRxDatasources


class XibCollectionCell: UICollectionViewCell, ModelledCollectionCell {
  
  @IBOutlet weak var value: UILabel!
  
  var cellModel: CollectionCellViewModel? {
    didSet {
      guard let viewModel = cellModel as? XibCollectionCellViewModel else { return }
      self.value.text = viewModel.value
    }
  }
}

extension XibCollectionCellViewModel: CollectionCellViewModel {
  var cellViewClass: CollectionCellType {
    return .nibType(name: "\(XibCollectionCell.self)")
  }
}

