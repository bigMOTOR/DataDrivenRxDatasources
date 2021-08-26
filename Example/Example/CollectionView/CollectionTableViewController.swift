//
//  CollectionTableViewController.swift
//  Example
//
//  Created by Dmitriy on 5/13/20.
//

import UIKit
import RxSwift
import RxCocoa

class CollectionTableViewController: UITableViewController {
  
  enum Segue: String {
    case toCollectionReloadExamples
    case toCollectionAnimatableExamples
  }
  
  var viewModel = CollectionnTableViewModel()
  private let _bag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = nil
    
    viewModel.actions
      .drive(onNext: { [unowned self] action in
        switch action {
        case .toCollectionReloadExamples:
          let model = CollectionViewModel()
          self.performSegue(withIdentifier: CollectionTableViewController.Segue.toCollectionReloadExamples.rawValue, sender: model)
          break;
        case .toCollectionAnimatableExamples:
          let model = AnimatableControllerViewModel()
          self.performSegue(withIdentifier: CollectionTableViewController.Segue.toCollectionAnimatableExamples.rawValue, sender: model)
          break;
        }
      })
      .disposed(by: _bag)
    
    tableView.rx
      .bind(sections: viewModel.sections)
      .disposed(by: _bag)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch (segue.identifier, segue.destination, sender) {
    case (Self.Segue.toCollectionReloadExamples.rawValue, let controller as CollectionViewController, let model as CollectionViewModel):
      controller.viewModel = model
    case (Self.Segue.toCollectionAnimatableExamples.rawValue, let controller as AnimatableCollectionViewController, let model as AnimatableControllerViewModel):
      controller.viewModel = model
    default:
      break;
    }
  }
}
