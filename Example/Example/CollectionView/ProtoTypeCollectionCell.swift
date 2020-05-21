//
//  ProtoTypeCollectionCell.swift
//  Example
//
//  Created by Dmitriy on 5/14/20.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import UIKit
import DataDrivenRxTableView

class ProtoTypeCollectionCell: UICollectionViewCell, ModelledCollectionCell {
  
  @IBOutlet weak var valueLabel: UILabel!
  
  var cellModel: CollectionCellViewModel? {
    didSet {
      guard let viewModel = cellModel as? ProtoTypeCollectionCellViewModel else { return }
      self.valueLabel.text = viewModel.value
    }
  }
}
extension ProtoTypeCollectionCellViewModel: CollectionCellViewModel {
  var cellViewClass: CollectionCellType {
    return .prototype(reuseId: "\(ProtoTypeCollectionCell.self)")
  }
  
}
