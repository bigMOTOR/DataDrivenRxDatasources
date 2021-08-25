//
//  HeaderFooterSectionType.swift
//  
//
//  Created by Mikhail Markin on 25.08.2021.
//

public enum HeaderFooterContent {
  case title(String)
  case view(HeaderFooterViewModel)
}

public protocol SectionHeaderFooterType: SectionHeaderTitleType, SectionFooterTitleType, SectionHeaderViewType, SectionFooterViewType {
  var sectionHeader: HeaderFooterContent? { get }
  var sectionFooter: HeaderFooterContent? { get }
}

extension SectionHeaderFooterType {
  public var sectionHeaderTitle: String? {
    guard
      let header = sectionHeader,
      case HeaderFooterContent.title(let title) = header
    else { return nil }
    return title
  }
}

extension SectionHeaderFooterType {
  public var sectionFooterTitle: String? {
    guard
      let footer = sectionFooter,
      case HeaderFooterContent.title(let title) = footer
    else { return nil }
    return title
  }
}

extension SectionHeaderFooterType {
  public var sectionHeaderViewModel: HeaderFooterViewModel? {
    guard
      let header = sectionHeader,
      case HeaderFooterContent.view(let model) = header
    else { return nil }
    return model
  }
}

extension SectionHeaderFooterType {
  public var sectionFooterViewModel: HeaderFooterViewModel? {
    guard
      let footer = sectionFooter,
      case HeaderFooterContent.view(let model) = footer
    else { return nil }
    return model
  }
}
