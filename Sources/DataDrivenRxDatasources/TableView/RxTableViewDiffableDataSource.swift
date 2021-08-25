//
//  RxTableViewDiffableDataSource.swift
//  
//
//  Created by Mikhail Markin on 21.08.2021.
//

import UIKit
import RxCocoa

@available(iOS 13.0, *)
final class RxTableViewDiffableDataSource<Section: Hashable, Item: Hashable>: UITableViewDiffableDataSource<Section, Item> {
  
  enum Error: Swift.Error {
    case outOfBounds(indexPath: IndexPath)
  }

  typealias TitleForHeaderInSectionProvider<DataSource: ExtendedSectionedViewDataSourceType> = (DataSource, Int) -> String?
  typealias TitleForFooterInSectionProvider<DataSource: ExtendedSectionedViewDataSourceType> = (DataSource, Int) -> String?
  typealias CanEditRowAtIndexPathProvider = (SectionedViewDataSourceType, IndexPath) -> Bool
  typealias CanMoveRowAtIndexPathProvider = (SectionedViewDataSourceType, IndexPath) -> Bool
  
  private let _titleForHeaderInSectionProvider: TitleForHeaderInSectionProvider<RxTableViewDiffableDataSource>
  private let _titleForFooterInSectionProvider: TitleForFooterInSectionProvider<RxTableViewDiffableDataSource>
  private let _canEditRowAtIndexPathProvider: CanEditRowAtIndexPathProvider
  private let _canMoveRowAtIndexPathProvider: CanMoveRowAtIndexPathProvider
  
  init(
    tableView: UITableView,
    cellProvider: @escaping CellProvider,
    titleForHeaderInSectionProvider: @escaping TitleForHeaderInSectionProvider<RxTableViewDiffableDataSource> = { _, _ in nil },
    titleForFooterInSectionProvider: @escaping TitleForFooterInSectionProvider<RxTableViewDiffableDataSource> = { _, _ in nil },
    canEditRowAtIndexPathProvider: @escaping CanEditRowAtIndexPathProvider = { _, _ in true },
    canMoveRowAtIndexPathProvider: @escaping CanMoveRowAtIndexPathProvider = { _, _ in true }
  ) {
    _titleForHeaderInSectionProvider = titleForHeaderInSectionProvider
    _titleForFooterInSectionProvider = titleForFooterInSectionProvider
    _canEditRowAtIndexPathProvider = canEditRowAtIndexPathProvider
    _canMoveRowAtIndexPathProvider = canMoveRowAtIndexPathProvider
    super.init(tableView: tableView, cellProvider: cellProvider)
  }
  
  // MARK: - UITableViewDataSource
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return _titleForHeaderInSectionProvider(self, section)
  }
  
  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return _titleForFooterInSectionProvider(self, section)
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return _canEditRowAtIndexPathProvider(self, indexPath)
  }
  
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return _canMoveRowAtIndexPathProvider(self, indexPath)
  }
}

@available(iOS 13.0, *)
extension RxTableViewDiffableDataSource: ExtendedSectionedViewDataSourceType {
  public func model(at indexPath: IndexPath) throws -> Any {
    guard let item = itemIdentifier(for: indexPath) else { throw Error.outOfBounds(indexPath: indexPath) }
    return item
  }
  
  public func sectionModel(at index: Int) -> Section? {
    let sections = snapshot().sectionIdentifiers
    guard index >= 0 && index < sections.count else { return nil }
    return sections[index]
  }
}
