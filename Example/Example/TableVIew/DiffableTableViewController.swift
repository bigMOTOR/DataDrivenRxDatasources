//
//  AnimatableTableViewController.swift
//  Example
//
//  Created by Dmitriy on 5/8/20.
//

import UIKit
import RxSwift
import RxCocoa

class DiffableTableViewController: UITableViewController {
  private let _bag = DisposeBag()
  
  var viewModel: DiffableViewModel!
  
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
