//
//  SampleCell.swift
//  
//
//  Created by Nikolay Fiantsev on 07.05.2020.
//

import UIKit
@testable import DataDrivenRxTableView

final class SampleCell: UITableViewCell, ModelledCell {
  var title: String!
  
  var cellModel: CellViewModel? {
    didSet {
      guard let vModel = cellModel as? SampleCellViewModel else { return }
      title = vModel.name
    }
  }   
}

extension SampleCellViewModel: CellViewModel {
  var cellViewClass: CellType {
    return .classType(SampleCell.self)
  }
}
