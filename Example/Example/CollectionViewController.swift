//
//  CollectionViewController.swift
//  Example
//
//  Created by Dmitriy on 5/13/20.
//

import UIKit
import RxSwift
import RxCocoa

class CollectionViewController: UICollectionViewController {
  
  private let _bag = DisposeBag()
  var viewModel: CollectionViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = nil
    collectionView.rx
      .bind(sections: viewModel.sections)
      .disposed(by: _bag)
  }
  
  @IBAction func addRow(_ sender: Any) {
    viewModel.insertRow()
  }
}
