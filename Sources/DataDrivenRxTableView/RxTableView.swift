//
//  RxTableView.swift
//  
//
//  Created by Nikolay Fiantsev on 05.05.2020.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

extension Reactive where Base: UITableView {
  // MARK: - ReloadDataSource
 public func bind<S: CustomStringConvertible>(sections: Driver<[AnyCellSectionModel<S>]>) -> Disposable {
    return CompositeDisposable(disposables: [
      sections
        .do(onNext: _cellRegistration)
        .drive(items(dataSource: reloadDataSource())),
      _addDelegate(),
      _bindActions()
      ])
  }
  
  // MARK: - CustomStringConvertible, Animatable
 public func bind<S: CustomStringConvertible>(sections: Driver<[AnimatableCellSectionModel<S>]>, animationConfiguration: AnimationConfiguration = AnimationConfiguration()) -> Disposable {
    return CompositeDisposable(disposables: [
      sections
        .do(onNext: _cellRegistration)
        .drive(items(dataSource: animatableDataSource(animationConfiguration: animationConfiguration))),
      _addDelegate(),
      _bindActions()
      ])
  }
  
  // MARK: - Section, Animatable
 public func bind<S>(sections: Driver<[AnimatableCellSectionModel<S>]>, animationConfiguration: AnimationConfiguration = AnimationConfiguration()) -> Disposable {
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableCellSectionModel<S>>(
      animationConfiguration: animationConfiguration,
      configureCell: { (_, tv, indexPath, model) in _configureCell(tv: tv, indexPath: indexPath, model: model) })
    
    return CompositeDisposable(disposables: [
      sections
        .do(onNext: _cellRegistration)
        .drive(items(dataSource: dataSource)),
      _addDelegate(),
      _bindActions()
      ])
  }
  
  // Cell registration
  private func _cellRegistration<S: SectionModelType>(_ sections: [S]) where S.Item: CellViewModelWrapper {
    let tableView = base
    sections
      .flatMap { $0.items }
      .forEach { modelWrapper in
        modelWrapper.base.cellViewClass.registerFor(table: tableView)
    }
  }

  // MARK: - Cell Actions
  private func _bindActions() -> Disposable {
    let tableView = base
    return CompositeDisposable(disposables: [
      // Cell selections
      modelSelected(CellViewModelWrapper.self)
        .subscribe(onNext: { model in
          (model.base as? CellViewModelWithActions)?.onSelected?()
        }),
      
      // Accessory selections
      itemAccessoryButtonTapped
        .subscribe(onNext: { indexPath in
          let modelledCell = tableView.cellForRow(at: indexPath) as? ModelledCell
          let model = modelledCell?.cellModel as? CellViewModelWithActions
          model?.onInfoTap?()
        }),
      
      // Item selections
      itemSelected
        .subscribe(onNext: { index in
          tableView.deselectRow(at: index, animated: true)
        })
      ])
  }
  
  // MARK: - Add Delegate
  private func _addDelegate() -> Disposable {
    let delegate = TableViewControllerDelegateProxy()
    base.delegate = delegate
    return Disposables.create { [delegate] in _ = delegate}
  }
}

func reloadDataSource<S: CustomStringConvertible>() -> RxTableViewSectionedReloadDataSource<AnyCellSectionModel<S>> {
  return RxTableViewSectionedReloadDataSource<AnyCellSectionModel<S>>(
    configureCell: { (_, tv, indexPath, model) in _configureCell(tv: tv, indexPath: indexPath, model: model) },
    titleForHeaderInSection: { dataSource, index in  dataSource.sectionModels[index].model.description })
}

func animatableDataSource<S: CustomStringConvertible>(animationConfiguration: AnimationConfiguration) -> RxTableViewSectionedAnimatedDataSource<AnimatableCellSectionModel<S>> {
  return RxTableViewSectionedAnimatedDataSource<AnimatableCellSectionModel<S>>(
    animationConfiguration: animationConfiguration,
    configureCell: { (_, tv, indexPath, model) in _configureCell(tv: tv, indexPath: indexPath, model: model) },
    titleForHeaderInSection: { dataSource, index in  dataSource.sectionModels[index].model.description })
}

private func _configureCell<C: CellViewModelWrapper>(tv: UITableView, indexPath: IndexPath, model: C) -> UITableViewCell {
  let cell = tv.dequeueReusableCell(withIdentifier: model.base.cellViewClass.identifier, for: indexPath)
  guard var modeledCell = cell as? ModelledCell else { return cell }
  modeledCell.cellModel = model.base
  return cell
}

// MARK: - TableViewControllerDelegateProxy
private final class TableViewControllerDelegateProxy: NSObject, UITableViewDelegate {
  func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    
    if let modelledCell = tableView.cellForRow(at: indexPath) as? ModelledCell, let model = modelledCell.cellModel as? CellViewModelWithActions {
      return model.onSelected != nil
    }

    return false
  }
}
