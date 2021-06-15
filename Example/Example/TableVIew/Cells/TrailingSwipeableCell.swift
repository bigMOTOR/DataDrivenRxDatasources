//
//  TrailingSwipeableCell.swift
//  Example
//
//  Created by Nikolay Fiantsev on 15.06.2021.
//  Copyright © 2021 Dmitriy. All rights reserved.
//

import UIKit
import DataDrivenRxDatasources

final class TrailingSwipeableCell: UITableViewCell, ModelledCell {
  
  var cellModel: CellViewModel? {
    didSet {
      guard let viewModel = cellModel as? TrailingSwipeableCellViewModel else { return }
      self.textLabel?.text = viewModel.title
      self.detailTextLabel?.text = viewModel.details
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension TrailingSwipeableCellViewModel: CellViewModel {
  var cellViewClass: CellType {
    return .classType(TrailingSwipeableCell.self)
  }
}
