//
//  ClassCollectionCell.swift
//  Example
//
//  Created by Dmitriy on 5/14/20.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import UIKit
import DataDrivenRxDatasources

class ClassCollectionCell: UICollectionViewCell, ModelledCollectionCell {
  private var _valueLabel: UILabel!
  
  override var isHighlighted: Bool {
    didSet {
      contentView.backgroundColor = isHighlighted ? .brown : .lightGray
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    _addLabel()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    _addLabel()
  }
  
  private func _addLabel() {
    _valueLabel = UILabel(frame: contentView.frame)
    _valueLabel.textAlignment = .center
    contentView.addSubview(_valueLabel)
  }
  
  var cellModel: CollectionCellViewModel? {
    didSet {
      guard let viewModel = cellModel as? ClassCollectionCellViewModel else { return }
      _valueLabel.text = viewModel.value
      contentView.backgroundColor = .lightGray
    }
  }
}

extension ClassCollectionCellViewModel: CollectionCellViewModel {
  var cellViewClass: CollectionCellType {
    return .classType(ClassCollectionCell.self)
  }
}
