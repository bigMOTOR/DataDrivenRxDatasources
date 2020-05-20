//
//  AnimatableTableViewController.swift
//  Example
//
//  Created by Dmitriy on 5/8/20.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AnimatableTableViewController: UITableViewController {
  private let _bag = DisposeBag()
  
  var viewModel: AnimatableViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = nil
    tableView.rx
      .bind(sections: viewModel.sections)
      .disposed(by: _bag)
  }
  @IBAction func insertNewRow() {
    viewModel.insertRow()
  }
}
