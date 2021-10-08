//
//  RxCollectionView.swift
//  
//
//  Created by Mikhail Markin on 07.05.2020.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

extension Reactive where Base: UICollectionView {
  // MARK: - Reload
  public func bind<S>(sections: Driver<[CollectionSectionModel<S>]>) -> Disposable {
    return CompositeDisposable(disposables: [
      sections
        .do(onNext: _registerCells(for: base))
        .drive(items(dataSource: _reloadDataSource())),
      _addDelegate(),
      _bindActions()
    ])
  }
  
  // MARK: - Animatable
  public func bind<S>(sections: Driver<[AnimatableCollectionSectionModel<S>]>, animationConfiguration: AnimationConfiguration = AnimationConfiguration()) -> Disposable {
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
    let collectionView = base
    return CompositeDisposable(disposables: [
      // Cell selections
      modelSelected(CollectionCellViewModelWrapper.self)
        .subscribe(onNext: { model in
          (model.base as? SelectableType)?.onSelected?()
        }),
      
      // Item selections
      itemSelected
        .subscribe(onNext: { index in
          collectionView.deselectItem(at: index, animated: true)
        })
    ])
  }
  
  // MARK: - Add Delegate
  private func _addDelegate() -> Disposable {
    let delegate = CollectionViewControllerDelegateProxy()
    base.delegate = delegate
    return Disposables.create { [delegate] in _ = delegate}
  }
}

// MARK: - Cell registration
private func _registerCells<S: SectionModelType>(for collectionView: UICollectionView) -> ([S]) -> () where S.Item: CollectionCellViewModelWrapper {
  return { sections in
    sections
      .flatMap { $0.items }
      .forEach { modelWrapper in
        modelWrapper.base.cellViewClass.registerFor(collection: collectionView)
    }
  }
}

// MARK: - DataSources
private func _reloadDataSource<S>() -> RxCollectionViewSectionedReloadDataSource<CollectionSectionModel<S>> {
  return RxCollectionViewSectionedReloadDataSource<CollectionSectionModel<S>>(
    configureCell: { (_, cv, indexPath, model) in _configureCell(cv: cv, indexPath: indexPath, model: model) }
  )
}

private func _animatableDataSource<S>(animationConfiguration: AnimationConfiguration) -> RxCollectionViewSectionedAnimatedDataSource<AnimatableCollectionSectionModel<S>> {
  return RxCollectionViewSectionedAnimatedDataSource<AnimatableCollectionSectionModel<S>>(
    animationConfiguration: animationConfiguration,
    configureCell: { (_, cv, indexPath, model) in _configureCell(cv: cv, indexPath: indexPath, model: model) }
  )
}

// MARK: - Configurations
private func _configureCell<C: CollectionCellViewModelWrapper>(cv: UICollectionView, indexPath: IndexPath, model: C) -> UICollectionViewCell {
  let cell = cv.dequeueReusableCell(withReuseIdentifier: model.base.cellViewClass.identifier, for: indexPath)
  guard var modeledCell = cell as? ModelledCollectionCell else { return cell }
  modeledCell.cellModel = model.base
  return cell
}

// MARK: - TableViewControllerDelegateProxy
private final class CollectionViewControllerDelegateProxy: NSObject, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    if
      let modelledCell = collectionView.cellForItem(at: indexPath) as? ModelledCollectionCell,
      let model = modelledCell.cellModel as? SelectableType {
      return model.onSelected != nil
    }
    return false
  }
  
  @available(iOS 13.0, *)
  func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    return (collectionView.cellForItem(at: indexPath) as? ModelledCollectionCell)
      .flatMap(\.cellModel)
      .flatMap { $0 as? ContextMenuInteractableType }
      .flatMap { contextMenuInteractable -> UIContextMenuConfiguration? in
        let contextActions = contextMenuInteractable.contextMenuActions.map(\.asUIAction)
        switch contextActions.isEmpty {
        case true:
          return nil
        case false:
          return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { action in
            UIMenu(title: contextMenuInteractable.contextMenuTitle, children: contextActions)
          }
        }
      }
  }
}
