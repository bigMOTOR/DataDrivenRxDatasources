//
//  HeadersAndFootersViewModel.swift
//  Example
//
//  Created by Nikolay Fiantsev on 31.07.2020.
//

import UIKit
import Foundation
import RxCocoa
import RxDataSources
import DataDrivenRxDatasources

struct HeadersAndFootersViewModel {
  enum Section: String {
    case identity
    case headerTitle
    case footerTitle
    case headerViewFooterView
  }
  
  let sections: Driver<[DiffableTableSectionModel<HeaderFooterSection<Section>>]>

  init() {
    let cells: () -> [IdentifiableCellViewModel] = {
      [ClassCellViewModel(value: UUID().uuidString, onSelected: { print("cell selected") })]
    }
    
    self.sections = .just([
      DiffableTableSectionModel(
        model: HeaderFooterSection(identity: .identity),
        items: cells()
      ),
      DiffableTableSectionModel(
        model: HeaderFooterSection(
          identity: .headerTitle,
          header: .title("Header title")
        ),
        items: cells()
      ),
      DiffableTableSectionModel(
        model: HeaderFooterSection(
          identity: .footerTitle,
          footer: .title("Footer title")
        ),
        items: cells()
      ),
      DiffableTableSectionModel(
        model: HeaderFooterSection(
          identity: .headerViewFooterView,
          header: .view(XibHeaderFooterViewModel(value: "Header view")),
          footer: .view(XibHeaderFooterViewModel(value: "Footer view"))
        ),
        items: cells()
      )
    ])
  }
}

struct HeaderFooterSection<Identity: Hashable>: SectionHeaderFooterType {
  let sectionHeader: HeaderFooterContent?
  let sectionFooter: HeaderFooterContent?
  let identity: Identity
  
  init(identity: Identity, header: HeaderFooterContent? = nil, footer: HeaderFooterContent? = nil) {
    self.identity = identity
    self.sectionHeader = header
    self.sectionFooter = footer
  }
}

extension HeaderFooterSection: IdentifiableType, Hashable {
  static func == (lhs: HeaderFooterSection, rhs: HeaderFooterSection) -> Bool {
    return lhs.identity == rhs.identity
  }
  
  func hash(into hasher: inout Hasher) {
    identity.hash(into: &hasher)
  }
}
