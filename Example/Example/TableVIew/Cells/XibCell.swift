//
//  TableViewCell.swift
//  Example
//
//  Created by Dmitriy on 5/7/20.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import UIKit
import DataDrivenRxTableView

final class XibCell: UITableViewCell, ModelledCell {
  
  @IBOutlet weak var valueLabel: UILabel!
  
  var cellModel: CellViewModel? {
    didSet {
      guard let viewModel = cellModel as? XibCellViewModel else { return }
      self.valueLabel.text = viewModel.value
    }
  }
}
extension XibCellViewModel: CellViewModel {
  var cellViewClass: CellType {
    return .nibType(name: "\(XibCell.self)")
  }
}
