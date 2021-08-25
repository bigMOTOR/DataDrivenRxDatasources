//
//  HeadersAndFootersViewController.swift
//  Example
//
//  Created by Nikolay Fiantsev on 31.07.2020.
//

import UIKit
import RxSwift
import RxCocoa

class HeadersAndFootersViewController: UITableViewController {
  private let _bag = DisposeBag()
  
  var viewModel: HeadersAndFootersViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = nil
    tableView.rx
      .bind(sections: viewModel.sections)
      .disposed(by: _bag)
  }
}
