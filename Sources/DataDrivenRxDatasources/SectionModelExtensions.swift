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

/// Protocol for viewModel that handles adding section header. (nil - will provide 0 header height)
public protocol SectionHeaderTitleType {
  var sectionHeaderTitle: String? { get }
}

/// Protocol for viewModel that handles adding section footer (nil - will provide 0 footer height)
public protocol SectionFooterTitleType {
  var sectionFooterTitle: String? { get }
}

extension String: SectionHeaderTitleType {
  public var sectionHeaderTitle: String? {
    return self
  }
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
}

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
