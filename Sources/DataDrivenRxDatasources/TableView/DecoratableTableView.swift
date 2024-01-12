//
//  DecoratableTableView.swift
//
//
//  Created by Khurshed Gulov on 11/01/24.
//

import Foundation
import UIKit

protocol DecoratableTableView where Self: UITableView {
  func applyDecoration(for indexPath: IndexPath)
}
