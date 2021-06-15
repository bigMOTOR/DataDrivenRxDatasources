//
//  SwipeAction.swift
//  
//
//  Created by Nikolay Fiantsev on 15.06.2021.
//

import Foundation
import UIKit.UIImage
import UIKit.UIColor

public struct SwipeAction {
  
  public enum Style {
    case normal
    case destructive
  }
  
  let style: Style
  let title: String?
  let image: UIImage?
  let backgroundColor: UIColor?
  let handler: ()->Void
  
  public init(style: SwipeAction.Style = .normal, title: String? = nil, image: UIImage? = nil, backgroundColor: UIColor? = nil, handler: @escaping () -> Void) {
    self.style = style
    self.title = title
    self.image = image
    self.backgroundColor = backgroundColor
    self.handler = handler
  }
}
