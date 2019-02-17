//
//  CellRepresentable.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import UIKit

protocol CellRepresentable {
    static func registerCell(tableView: UITableView)
    func cellInstance(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}
