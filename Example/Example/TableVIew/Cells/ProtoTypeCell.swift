//
//  ProtoTypeCell.swift
//  Example
//
//  Created by Mikhail Markin on 09.05.2020.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import UIKit
import DataDrivenRxDatasources

final class ProtoTypeCell: UITableViewCell, ModelledCell {
  
  @IBOutlet weak var valueLabel: UILabel!
  
  var cellModel: CellViewModel? {
    didSet {
      guard let viewModel = cellModel as? ProtoTypeCellViewModel else { return }
      self.valueLabel.text = viewModel.value
    }
  }
}
extension ProtoTypeCellViewModel: CellViewModel {
  var cellViewClass: CellType {
    return .prototype(reuseId: "\(ProtoTypeCell.self)")
  }
}
