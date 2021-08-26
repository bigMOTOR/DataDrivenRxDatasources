//
//  ClassCell.swift
//  Example
//
//  Created by Mikhail Markin on 09.05.2020.
//

import UIKit
import DataDrivenRxDatasources

final class ClassCell: UITableViewCell, ModelledCell {
  
  var cellModel: CellViewModel? {
    didSet {
      guard let viewModel = cellModel as? ClassCellViewModel else { return }
      accessoryType = viewModel.onSelected == nil ? .none : .disclosureIndicator
      self.textLabel?.text = viewModel.value
    }
  }
}
extension ClassCellViewModel: CellViewModel {
  var cellViewClass: CellType {
    return .classType(ClassCell.self)
  }
}
