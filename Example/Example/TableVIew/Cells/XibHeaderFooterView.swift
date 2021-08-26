//
//  XibHeaderFooterView.swift
//  Example
//
//  Created by Mikhail Markin on 25.08.2021.
//

import UIKit
import DataDrivenRxDatasources

final class XibHeaderFooterView: UITableViewHeaderFooterView, ModelledHeaderFooterView {
  
  @IBOutlet weak var valueLabel: UILabel!
  
  var headerFooterModel: HeaderFooterViewModel? {
    didSet {
      guard let viewModel = headerFooterModel as? XibHeaderFooterViewModel else { return }
      self.valueLabel.text = viewModel.value
    }
  }
}

extension XibHeaderFooterViewModel: HeaderFooterViewModel {
  var headerFooterViewClass: HeaderFooterType {
    return .nibType(name: "\(XibHeaderFooterView.self)")
  }
}
