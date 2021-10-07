//
//  ContextMenuAction.swift
//  
//
//  Created by Nikolay Fiantsev on 07.10.2021.
//

import Foundation
import UIKit.UIImage

@available(iOS 13.0, *)
public struct ContextMenuAction {
  
  public enum Style {
    case normal
    case destructive
    case disabled
  }
  
  public enum State {
    case on
    case off
  }
  
  let title: String
  let style: Style
  let state: State
  let image: UIImage?
  let handler: ()->Void
  
  public init(title: String, style: Style = .normal, state: State = .off, image: UIImage? = nil, handler: @escaping () -> Void) {
    self.title = title
    self.style = style
    self.state = state
    self.image = image
    self.handler = handler
  }
  
}

@available(iOS 13.0, *)
extension ContextMenuAction {
  var asUIAction: UIAction {
    return .init(title: title,
                 image: image,
                 attributes: style.attributes,
                 state: state == .on ? .on : .off) { _ in
      handler()
    }
  }
}

@available(iOS 13.0, *)
private extension ContextMenuAction.Style {
  var attributes: UIMenuElement.Attributes {
    switch self {
    case .normal:
      return []
    case .destructive:
      return .destructive
    case .disabled:
      return .disabled
    }
  }
}
