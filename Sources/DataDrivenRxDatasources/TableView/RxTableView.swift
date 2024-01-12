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
    let dataSource: RxTableViewSectionedReloadDataSource<TableSectionModel<S>> = _reloadDataSource()
    return CompositeDisposable(disposables: [
      sections
        .do(onNext: _registerReusables(for: base))
        .drive(items(dataSource: dataSource)),
      _addDelegate(using: dataSource),
      _bindActions()
    ])
  }
  
  // MARK: - Animatable
  public func bind<S>(sections: Driver<[AnimatableTableSectionModel<S>]>, animationConfiguration: AnimationConfiguration = AnimationConfiguration()) -> Disposable {
    let dataSource: RxTableViewSectionedAnimatedDataSource<AnimatableTableSectionModel<S>> = _animatableDataSource(animationConfiguration: animationConfiguration)
    return CompositeDisposable(disposables: [
      sections
        .do(onNext: _registerReusables(for: base))
        .drive(items(dataSource: dataSource)),
      _addDelegate(using: dataSource),
      _bindActions()
    ])
  }
  
  @available(iOS 13.0, *)
  public func bind<S>(sections: Driver<[DiffableTableSectionModel<S>]>, rowAnimation: UITableView.RowAnimation = .automatic) -> Disposable {
    let dataSource: RxTableViewDiffableDataSource<S, DiffableCellViewModel> = _diffableDataSource(tableView: base, rowAnimation: rowAnimation)
    var firstLoad = true
    
    // merging with .never to keep subscription live and dataSource not released
    let diffableSections = Driver.merge(sections, .never())
      .do(onNext: _registerReusables(for: base))
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
      _addDelegate(using: dataSource),
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
  private func _addDelegate<DataSource: ExtendedSectionedViewDataSourceType & AnyObject>(using dataSource: DataSource) -> Disposable {
    let delegate = TableViewControllerDelegateProxy(dataSource: dataSource)
    base.delegate = delegate
    return Disposables.create { [delegate] in _ = delegate }
  }
}

// MARK: - Cell registration
private func _registerReusables<S: SectionModelType & ModelType>(for tableView: UITableView) -> ([S]) -> () where S.Item: CellViewModelWrapper {
  return { sections in
    sections
      .forEach { section in
        (section.model as? SectionHeaderViewType)
          .flatMap(\.sectionHeaderViewModel)
          .map(\.headerFooterViewClass)?
          .registerFor(table: tableView)
        
        (section.model as? SectionFooterViewType)
          .flatMap(\.sectionFooterViewModel)
          .map(\.headerFooterViewClass)?
          .registerFor(table: tableView)
        
        section.items
          .forEach { modelWrapper in
            modelWrapper.base.cellViewClass.registerFor(table: tableView)
          }
      }
  }
}

// MARK: - DataSources
private func _reloadDataSource<S>() -> RxTableViewSectionedReloadDataSource<TableSectionModel<S>> {
  return RxTableViewSectionedReloadDataSource<TableSectionModel<S>>(
    configureCell: { (_, tv, indexPath, model) in _configureCell(tv: tv, indexPath: indexPath, model: model) },
    titleForHeaderInSection: _titleForHeaderInSection,
    titleForFooterInSection: _titleForFooterInSection,
    canEditRowAtIndexPath: _canEditRowAtIndexPath,
    canMoveRowAtIndexPath: _canMoveRowAtIndexPath
  )
}

private func _animatableDataSource<S>(animationConfiguration: AnimationConfiguration) -> RxTableViewSectionedAnimatedDataSource<AnimatableTableSectionModel<S>> {
  return RxTableViewSectionedAnimatedDataSource<AnimatableTableSectionModel<S>>(
    animationConfiguration: animationConfiguration,
    configureCell: { (_, tv, indexPath, model) in _configureCell(tv: tv, indexPath: indexPath, model: model) },
    titleForHeaderInSection: _titleForHeaderInSection,
    titleForFooterInSection: _titleForFooterInSection,
    canEditRowAtIndexPath: _canEditRowAtIndexPath,
    canMoveRowAtIndexPath: _canMoveRowAtIndexPath
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
  case is DragReorderedType:
    return true
  default:
    return false
  }
}

private func _canMoveRowAtIndexPath(dataSource: SectionedViewDataSourceType, indexPath: IndexPath) -> Bool {
  guard let model = try? dataSource.model(at: indexPath) as? CellViewModelWrapper else { return false }
  return model.base is DragReorderedType
}

// MARK: - TableViewControllerDelegateProxy
private final class TableViewControllerDelegateProxy<DataSource: ExtendedSectionedViewDataSourceType & AnyObject>: NSObject, UITableViewDelegate {
  private weak var _dataSource: DataSource!
  
  init(dataSource: DataSource) {
    _dataSource = dataSource
  }
  
  func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    guard
      let model = try? _dataSource.model(at: indexPath) as? CellViewModelWrapper,
      let selectableModel = model.base as? SelectableType
    else { return false }
    return selectableModel.onSelected != nil
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return (
      tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section) == nil
      && _sectionHeaderModel(at: section) == nil
    )
    ? .leastNormalMagnitude
    : UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return (
      tableView.dataSource?.tableView?(tableView, titleForFooterInSection: section) == nil
      && _sectionFooterModel(at: section) == nil
    )
    ? .leastNormalMagnitude
    : UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    guard
      let model = try? _dataSource.model(at: indexPath) as? CellViewModelWrapper,
      let trailingModel = model.base as? TrailingSwipeableType
    else { return nil }
    let configuration = UISwipeActionsConfiguration(actions: trailingModel.trailingSwipeActions.map(\.contextualAction))
    configuration.performsFirstActionWithFullSwipe = trailingModel.performsFirstActionWithFullSwipe
    return configuration
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return _sectionHeaderModel(at: section)
      .flatMap(_headerFooterView(tableView: tableView))
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return _sectionFooterModel(at: section)
      .flatMap(_headerFooterView(tableView: tableView))
  }
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .none
  }
  
  func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
    return false
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let tableView = tableView as? DecoratableTableView else { return }
    tableView.applyDecoration(for: indexPath)
  }
  
  private func _sectionHeaderModel(at index: Int) -> HeaderFooterViewModel? {
    return _dataSource.sectionModel(at: index)
      .flatMap { $0 as? SectionHeaderViewType }
      .flatMap(\.sectionHeaderViewModel)
  }
  
  private func _sectionFooterModel(at index: Int) -> HeaderFooterViewModel? {
    return _dataSource.sectionModel(at: index)
      .flatMap { $0 as? SectionFooterViewType }
      .flatMap(\.sectionFooterViewModel)
  }
}

private func _headerFooterView(tableView: UITableView) -> (HeaderFooterViewModel) -> UITableViewHeaderFooterView? {
  return { model in
    let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: model.headerFooterViewClass.identifier)
    guard var modeledView = view as? ModelledHeaderFooterView else { return view }
    modeledView.headerFooterModel = model
    return view
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
