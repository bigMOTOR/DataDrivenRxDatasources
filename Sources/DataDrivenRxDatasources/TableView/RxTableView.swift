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
  
  @available(iOS 13.0, *)
  public func bind<S>(sections: Driver<[DiffableTableSectionModel<S>]>, rowAnimation: UITableView.RowAnimation = .automatic) -> Disposable {
    let dataSource: RxTableViewDiffableDataSource<S, DiffableCellViewModel> = _diffableDataSource(tableView: base, rowAnimation: rowAnimation)
    var firstLoad = true
    
    // merging with .never to keep subscription live and dataSource not released
    let diffableSections = Driver.merge(sections, .never())
      .do(onNext: _registerCells(for: base))
      .map { sections in
        var snapshot = NSDiffableDataSourceSnapshot<S, DiffableCellViewModel>()
        snapshot.appendSections(sections.map(\.model))
        sections.forEach { section in
          snapshot.appendItems(section.items, toSection: section.model)
        }
        return snapshot
      }
      .drive(onNext: { snapshot in
        dataSource.apply(snapshot, animatingDifferences: !firstLoad, completion: { firstLoad = false })
      })
    
    return CompositeDisposable(disposables: [
      diffableSections,
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
      
      // Cell deletion
      modelDeleted(CellViewModelWrapper.self)
        .subscribe(onNext: { model in
          guard let deletableModel = model.base as? DeletableType else { return }
          deletableModel.onDeleted?()
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
    return Disposables.create { [delegate] in _ = delegate }
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

private func _animatableDataSource<S>(animationConfiguration: AnimationConfiguration) -> RxTableViewSectionedAnimatedDataSource<AnimatableTableSectionModel<S>> {
  return RxTableViewSectionedAnimatedDataSource<AnimatableTableSectionModel<S>>(
    animationConfiguration: animationConfiguration,
    configureCell: { (_, tv, indexPath, model) in _configureCell(tv: tv, indexPath: indexPath, model: model) },
    titleForHeaderInSection: _titleForHeaderInSection,
    titleForFooterInSection: _titleForFooterInSection,
    canEditRowAtIndexPath: _canEditRowAtIndexPath
  )
}

@available(iOS 13.0, *)
private func _diffableDataSource<S>(tableView: UITableView, rowAnimation: UITableView.RowAnimation) -> RxTableViewDiffableDataSource<S, DiffableCellViewModel> {
  let dataSource = RxTableViewDiffableDataSource<S, DiffableCellViewModel>(
    tableView: tableView,
    cellProvider: _configureCell,
    titleForHeaderInSectionProvider: _titleForHeaderInSection,
    titleForFooterInSectionProvider: _titleForFooterInSection,
    canEditRowAtIndexPathProvider: _canEditRowAtIndexPath
  )
  dataSource.defaultRowAnimation = rowAnimation
  return dataSource
}

// MARK: - Configurations
private func _configureCell<C: CellViewModelWrapper>(tv: UITableView, indexPath: IndexPath, model: C) -> UITableViewCell {
  let cell = tv.dequeueReusableCell(withIdentifier: model.base.cellViewClass.identifier, for: indexPath)
  guard var modeledCell = cell as? ModelledCell else { return cell }
  modeledCell.cellModel = model.base
  guard var expandableCell = cell as? ExpandableCell else { return cell }
  expandableCell.setReload(with: tv)
  return cell
}

private func _titleForHeaderInSection<DataSource: ExtendedSectionedViewDataSourceType>(dataSource: DataSource, index: Int) -> String? {
  return (dataSource.sectionModel(at: index) as? SectionHeaderTitleType)?.sectionHeaderTitle
}

private func _titleForFooterInSection<DataSource: ExtendedSectionedViewDataSourceType>(dataSource: DataSource, index: Int) -> String? {
  return (dataSource.sectionModel(at: index) as? SectionFooterTitleType)?.sectionFooterTitle
}

private func _canEditRowAtIndexPath(dataSource: SectionedViewDataSourceType, indexPath: IndexPath) -> Bool {
  guard let model = try? dataSource.model(at: indexPath) as? CellViewModelWrapper else { return false }
  
  switch model.base {
  case let deletableType as DeletableType:
    return deletableType.onDeleted != nil
  case let trailingSwipeableType as TrailingSwipeableType:
    return trailingSwipeableType.trailingSwipeActions.count > 0
  default:
    return false
  }
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
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    guard
      let modelledCell = tableView.cellForRow(at: indexPath) as? ModelledCell,
      let model = modelledCell.cellModel as? TrailingSwipeableType
      else { return nil }
    
    return UISwipeActionsConfiguration(actions: model.trailingSwipeActions.map(\.contextualAction))
  }
}

private extension SwipeAction {
  var contextualAction: UIContextualAction {
    let contextualAction = UIContextualAction(style: style.contextualActionStyle, title: title) { _, _, completionHandler in
      handler()
      completionHandler(true)
    }
    
    contextualAction.image = image
    
    if let customColor = backgroundColor {
      contextualAction.backgroundColor = customColor
    }
    
    return contextualAction
  }
}

private extension SwipeAction.Style {
  var contextualActionStyle: UIContextualAction.Style {
    switch self {
    case .normal:
      return .normal
    case .destructive:
      return .destructive
    }
  }
}
