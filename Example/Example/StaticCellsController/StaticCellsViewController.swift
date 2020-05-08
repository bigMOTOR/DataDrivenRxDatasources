//
//  StaticCellsViewController.swift
//  Example
//
//  Created by Dmitriy on 5/7/20.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StaticCellsViewController: UITableViewController {
  
  var viewModel = StaticCellsViewModel()
  private let _bag = DisposeBag()
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = nil
    tableView.dataSource = nil
    tableView.rx
      .bind(sections: viewModel.sections)
      .disposed(by: _bag)
  }
}
