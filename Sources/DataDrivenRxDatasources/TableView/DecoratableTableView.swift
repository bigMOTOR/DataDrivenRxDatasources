//
//  DecoratableTableView.swift
//
//
//  Created by Khurshed Gulov on 11/01/24.
//

import UIKit

public protocol DecoratableTableView where Self: UITableView {
  func applyDecoration(for indexPath: IndexPath, to cell: UITableViewCell)
}
