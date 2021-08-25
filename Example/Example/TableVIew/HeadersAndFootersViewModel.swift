//
//  HeadersAndFootersViewModel.swift
//  Example
//
//  Created by Nikolay Fiantsev on 31.07.2020.
//

import Foundation
import RxCocoa
import RxDataSources
import DataDrivenRxDatasources

struct HeadersAndFootersViewModel {
  let sections: Driver<[AnimatableTableSectionModel<HeaderFooterSection>]>

  init() {
    let cells: [IdentifiableCellViewModel] = [ClassCellViewModel(value: "Some Cell", onSelected: { print("cell selected") })]
    
    self.sections = .just([
      AnimatableTableSectionModel(model: HeaderFooterSection(identity: UUID().uuidString), items: cells),
      AnimatableTableSectionModel(model: HeaderFooterSection(header: "Some Header"), items: cells),
      AnimatableTableSectionModel(model: HeaderFooterSection(footer: "Some Footer"), items: cells),
      AnimatableTableSectionModel(model: HeaderFooterSection(header: "Some Header", footer: "Some Footer"), items: cells)
    ])
  }
}

struct HeaderFooterSection: SectionHeaderTitleType, SectionFooterTitleType {
  let sectionHeaderTitle: String?
  let sectionFooterTitle: String?
  private var _identity: String
  
  init(header: String? = nil, footer: String? = nil) {
    self.sectionHeaderTitle = header
    self.sectionFooterTitle = footer
    self._identity = (sectionHeaderTitle ?? "") + (sectionFooterTitle ?? "")
  }
  
  init(identity: String) {
    self._identity = identity
    self.sectionHeaderTitle = nil
    self.sectionFooterTitle = nil
  }
}

extension HeaderFooterSection: IdentifiableType {
  var identity: String {  return _identity }
}
