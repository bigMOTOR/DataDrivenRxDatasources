//
//  MainTableViewController.swift
//  Example
//
//  Created by Mikhail Markin on 09.05.2020.
//

import UIKit
import RxSwift
import RxCocoa

class MainTableViewController: UITableViewController {
  
  enum Segue: String {
    case toReloadExamples
    case toAnimatableExamples
    case toHeadersAndFootersExamples
  }
  
  var viewModel = MainTableViewModel()
  private let _bag = DisposeBag()
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = nil
    
    viewModel.actions
      .drive(onNext: { [unowned self] action in
        switch action {
        case .toReloadExamples:
          let model = ReloadTableViewModel()
          self.performSegue(withIdentifier: MainTableViewController.Segue.toReloadExamples.rawValue, sender: model)
        case .toAnimatableExamples:
          let model = AnimatableViewModel()
          self.performSegue(withIdentifier: MainTableViewController.Segue.toAnimatableExamples.rawValue, sender: model)
        case .toHeadersAndFooters:
          let model = HeadersAndFootersViewModel()
          self.performSegue(withIdentifier: MainTableViewController.Segue.toHeadersAndFootersExamples.rawValue, sender: model)
        }
      })
      .disposed(by: _bag)
    
    tableView.rx
      .bind(sections: viewModel.sections)
      .disposed(by: _bag)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch (segue.identifier, segue.destination, sender) {
    case (Self.Segue.toReloadExamples.rawValue, let controller as ReloadTableViewController, let model as ReloadTableViewModel):
      controller.viewModel = model
    case (Self.Segue.toAnimatableExamples.rawValue, let controller as AnimatableTableViewController, let model as AnimatableViewModel):
      controller.viewModel = model
    case (Self.Segue.toHeadersAndFootersExamples.rawValue, let controller as HeadersAndFootersViewController, let model as HeadersAndFootersViewModel):
      controller.viewModel = model
    default:
      break;
    }
  }
}
