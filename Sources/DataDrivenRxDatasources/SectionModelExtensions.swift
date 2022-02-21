//
//  SectionModelExtensions.swift
//  
//
//  Created by Nikolay Fiantsev on 05.05.2020.
//

import Foundation
import RxDataSources

// Helper Protocol used in dataSource
protocol ModelType {
  associatedtype Model
  var model: Model { get }
}

extension TableSectionModel: ModelType {}
extension AnimatableTableSectionModel: ModelType {}
@available(iOS 13.0, *)
extension DiffableTableSectionModel: ModelType {}

// MARK: - Additional Section functionality

/// Protocol for section model  that handles adding section header. (nil - will provide 0 header height)
public protocol SectionHeaderTitleType {
  var sectionHeaderTitle: String? { get }
}

/// Protocol for section model that handles adding section footer (nil - will provide 0 footer height)
public protocol SectionFooterTitleType {
  var sectionFooterTitle: String? { get }
}

extension String: SectionHeaderTitleType {
  public var sectionHeaderTitle: String? {
    return self
  }
}

/// Protocol for section model  that handles adding section header view
public protocol SectionHeaderViewType {
  var sectionHeaderViewModel: HeaderFooterViewModel? { get }
}

/// Protocol for section model that handles adding section footer view
public protocol SectionFooterViewType {
  var sectionFooterViewModel: HeaderFooterViewModel? { get }
}

// Protocol for viewModel that handles cell selection
public protocol SelectableType {
  var onSelected:(() -> Void)? { get }
}

// Protocol for viewModel that handles taps on accessory info button in UITableViewCell
public protocol InfoTappableType {
  var onInfoTap:(() -> Void)? { get }
}

// Protocol for viewModel that handles cell swipe to delete
public protocol DeletableType {
  var onDeleted:(() -> Void)? { get }
}

// Protocol for viewModel that provide and handles trailing swipe actions
public protocol TrailingSwipeableType {
  var trailingSwipeActions: [SwipeAction] { get }
  var performsFirstActionWithFullSwipe: Bool { get }
}

extension TrailingSwipeableType {
  public var performsFirstActionWithFullSwipe: Bool {
    return true
  }
}

// Protocol for viewModel that provides and handles ContextMenu call
@available(iOS 13.0, *)
public protocol ContextMenuInteractableType {
  var contextMenuTitle: String { get }
  var contextMenuActions: [ContextMenuAction] { get }
}

@available(iOS 13.0, *)
extension ContextMenuInteractableType {
  public var contextMenuTitle: String {
    return ""
  }
}

// Protocol for viewModel that enable drag tableview rows
public protocol DragReorderedType {}

// Protocol for UITableViewCell to update constraints and redraw cell
import UIKit.UITableView

public protocol ExpandableCell {
  var reload: (() -> Void)? { get set }
}

extension ExpandableCell {
  public mutating func setReload(with tableView: UITableView) {
    reload = { [weak tableView] in
      tableView?.beginUpdates()
      tableView?.updateConstraintsIfNeeded()
      tableView?.endUpdates()
    }
  }
}
