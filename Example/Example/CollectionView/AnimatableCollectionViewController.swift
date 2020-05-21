//
//  AnimatableCollectionViewController.swift
//  Example
//
//  Created by Dmitriy on 5/14/20.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AnimatableCollectionViewController: UICollectionViewController {
  
  private let _bag = DisposeBag()
  var viewModel: AnimatableControllerViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = nil
    collectionView.rx
      .bind(sections: viewModel.sections)
      .disposed(by: _bag)
  }
  
  @IBAction func addCell(_ sender: Any) {
    viewModel.insertRow()
  }
  
}
