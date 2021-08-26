//
//  ExtendedSectionedViewDataSourceType.swift
//  
//
//  Created by Mikhail Markin on 25.08.2021.
//

import RxCocoa
import RxDataSources

protocol ExtendedSectionedViewDataSourceType: SectionedViewDataSourceType {
  associatedtype Section
  func sectionModel(at index: Int) -> Section?
}

extension TableViewSectionedDataSource: ExtendedSectionedViewDataSourceType where Section: ModelType {
  func sectionModel(at index: Int) -> Section.Model? {
    return sectionModels[index].model
  }
}
