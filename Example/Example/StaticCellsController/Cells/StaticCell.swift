//
//  TableViewCell.swift
//  Example
//
//  Created by Dmitriy on 5/7/20.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import UIKit
import DataDrivenRxTableView

class StaticCell: UITableViewCell, ModelledCell {
  
  @IBOutlet weak var value: UILabel!
  
  var cellModel: CellViewModel? {
    didSet {
      guard let viewModel = cellModel as? StaticCellViewModel else { return }
      self.value.text = viewModel.value
    }
  }
}
extension StaticCellViewModel: CellViewModel {
  var cellViewClass: CellType {
    return .nibType(name: "\(StaticCell.self)")
  }
}
