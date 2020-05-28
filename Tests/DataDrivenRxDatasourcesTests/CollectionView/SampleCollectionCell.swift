//
//  SampleCollectionCell.swift
//  
//
//  Created by Mikhail Markin on 07.05.2020.
//

import UIKit
@testable import DataDrivenRxDatasources

final class SampleCollectionCell: UICollectionViewCell, ModelledCollectionCell {
  var title: String!
  
  var cellModel: CollectionCellViewModel? {
    didSet {
      guard let vModel = cellModel as? SampleCollectionCellViewModel else { return }
      title = vModel.name
    }
  }
}

extension SampleCollectionCellViewModel: CollectionCellViewModel {
  var cellViewClass: CollectionCellType {
    return .classType(SampleCollectionCell.self)
  }
}

