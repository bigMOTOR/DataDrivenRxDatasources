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
  public func bind<S>(sections: Driver<[AnimatableTableSectionModel<S>]>, animation: Animation = .configuration(AnimationConfiguration())) -> Disposable {
    return CompositeDisposable(disposables: [
      sections
        .do(onNext: _registerCells(for: base))
        .drive(items(dataSource: _animatableDataSource(animation: animation))),
      _addDelegate(),
      _bindActions()
    ])
  }
  
  public func bind<S>(sections: Driver<[AnimatableTableSectionModel<S>]>, animationConfiguration: AnimationConfiguration) -> Disposable {
    return bind(sections: sections, animation: .configuration(animationConfiguration))
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
      
      // Cell deletion
      modelDeleted(CellViewModelWrapper.self)
        .subscribe(onNext: { model in
          guard let editableModel = model.base as? EditableType else { return }
          editableModel.onDeleted?()
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
    titleForFooterInSection: _titleForFooterInSection,
    canEditRowAtIndexPath: _canEditRowAtIndexPath
  )
}

private func _animatableDataSource<S>(animation: Animation) -> RxTableViewSectionedAnimatedDataSource<AnimatableTableSectionModel<S>> {
  switch animation {
  case .configuration(let animationConfiguration):
    return RxTableViewSectionedAnimatedDataSource<AnimatableTableSectionModel<S>>(
      animationConfiguration: animationConfiguration,
      configureCell: { (_, tv, indexPath, model) in _configureCell(tv: tv, indexPath: indexPath, model: model) },
      titleForHeaderInSection: _titleForHeaderInSection,
      titleForFooterInSection: _titleForFooterInSection,
      canEditRowAtIndexPath: _canEditRowAtIndexPath
    )
  case .none:
    return RxTableViewSectionedNonAnimatedDataSource<AnimatableTableSectionModel<S>>(
      configureCell: { (_, tv, indexPath, model) in _configureCell(tv: tv, indexPath: indexPath, model: model) },
      titleForHeaderInSection: _titleForHeaderInSection,
      titleForFooterInSection: _titleForFooterInSection,
      canEditRowAtIndexPath: _canEditRowAtIndexPath
    )
  }
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

private func _canEditRowAtIndexPath<S: SectionModelType & ModelType>(dataSource: TableViewSectionedDataSource<S>, indexPath: IndexPath) -> Bool {
  if
    let model = try? dataSource.model(at: indexPath) as? CellViewModelWrapper,
    let editableModel = model.base as? EditableType {
    return editableModel.canEdit
  }
  return false
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
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return (tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section) == nil)
      ? .leastNormalMagnitude
      : UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return (tableView.dataSource?.tableView?(tableView, titleForFooterInSection: section) == nil)
      ? .leastNormalMagnitude
      : UITableView.automaticDimension
  }
}

// MARK: - Data Source that disables animation on table view updates (history of this: https://github.com/RxSwiftCommunity/RxDataSources/issues/90)
final class RxTableViewSectionedNonAnimatedDataSource<Section: AnimatableSectionModelType>: RxTableViewSectionedAnimatedDataSource<Section> {
  override func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
    UIView.performWithoutAnimation {
      super.tableView(tableView, observedEvent: observedEvent)
    }
  }
}
