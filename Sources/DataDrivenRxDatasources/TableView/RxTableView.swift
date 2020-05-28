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
  // MARK: - Reload
  public func bind<S>(sections: Driver<[TableSectionModel<S>]>) -> Disposable {
    return CompositeDisposable(disposables: [
      sections
        .do(onNext: _registerCells(for: base))
        .drive(items(dataSource: _reloadDataSource())),
      _addDelegate(),
      _bindActions()
    ])
  }
  
  // MARK: - Animatable
  public func bind<S>(sections: Driver<[AnimatableTableSectionModel<S>]>, animationConfiguration: AnimationConfiguration = AnimationConfiguration()) -> Disposable {
    return CompositeDisposable(disposables: [
      sections
        .do(onNext: _registerCells(for: base))
        .drive(items(dataSource: _animatableDataSource(animationConfiguration: animationConfiguration))),
      _addDelegate(),
      _bindActions()
    ])
  }
  
  // MARK: - Cell Actions
  private func _bindActions() -> Disposable {
    let tableView = base
    return CompositeDisposable(disposables: [
      // Cell selections
      modelSelected(CellViewModelWrapper.self)
        .subscribe(onNext: { model in
          (model.base as? SelectableType)?.onSelected?()
        }),
      
      
      // Accessory selections
      itemAccessoryButtonTapped
        .subscribe(onNext: { indexPath in
          let modelledCell = tableView.cellForRow(at: indexPath) as? ModelledCell
          let model = modelledCell?.cellModel as? InfoTappableType
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

// MARK: - Cell registration
private func _registerCells<S: SectionModelType>(for tableView: UITableView) -> ([S]) -> () where S.Item: CellViewModelWrapper {
  return { sections in
    sections
      .flatMap { $0.items }
      .forEach { modelWrapper in
        modelWrapper.base.cellViewClass.registerFor(table: tableView)
    }
  }
}

// MARK: - DataSources
private func _reloadDataSource<S>() -> RxTableViewSectionedReloadDataSource<TableSectionModel<S>> {
  return RxTableViewSectionedReloadDataSource<TableSectionModel<S>>(
    configureCell: { (_, tv, indexPath, model) in _configureCell(tv: tv, indexPath: indexPath, model: model) },
    titleForHeaderInSection: _titleForHeaderInSection,
    titleForFooterInSection: _titleForFooterInSection
  )
}

private func _animatableDataSource<S>(animationConfiguration: AnimationConfiguration) -> RxTableViewSectionedAnimatedDataSource<AnimatableTableSectionModel<S>> {
  return RxTableViewSectionedAnimatedDataSource<AnimatableTableSectionModel<S>>(
    animationConfiguration: animationConfiguration,
    configureCell: { (_, tv, indexPath, model) in _configureCell(tv: tv, indexPath: indexPath, model: model) },
    titleForHeaderInSection: _titleForHeaderInSection,
    titleForFooterInSection: _titleForFooterInSection
  )
}

// MARK: - Configurations
private func _titleForHeaderInSection<S: SectionModelType & ModelType>(dataSource: TableViewSectionedDataSource<S>, index: Int) -> String? {
  guard let model = dataSource.sectionModels[index].model as? SectionHeaderTitleType else { return nil }
  return model.sectionHeaderTitle
}

private func _titleForFooterInSection<S: SectionModelType & ModelType>(dataSource: TableViewSectionedDataSource<S>, index: Int) -> String? {
  guard let model = dataSource.sectionModels[index].model as? SectionFooterTitleType else { return nil }
  return model.sectionFooterTitle
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
    if
      let modelledCell = tableView.cellForRow(at: indexPath) as? ModelledCell,
      let model = modelledCell.cellModel as? SelectableType {
      return model.onSelected != nil
    }
    return false
  }
}
