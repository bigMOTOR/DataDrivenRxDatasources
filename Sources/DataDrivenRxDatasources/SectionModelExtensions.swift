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

// MARK: - Additional Section functionality

// Protocol for viewModel that handles adding section header
public protocol SectionHeaderTitleType {
  var sectionHeaderTitle: String { get }
}

// Protocol for viewModel that handles adding section header
public protocol SectionFooterTitleType {
  var sectionFooterTitle: String? { get }
}

extension String: SectionHeaderTitleType {
  public var sectionHeaderTitle: String {
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
