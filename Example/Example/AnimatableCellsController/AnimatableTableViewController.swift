//
//  AnimatableTableViewController.swift
//  Example
//
//  Created by Dmitriy on 5/8/20.
//  Copyright © 2020 Dmitriy. All rights reserved.
//

import UIKit

class AnimatableTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.delegate = nil
      tableView.dataSource = nil
    }



}
