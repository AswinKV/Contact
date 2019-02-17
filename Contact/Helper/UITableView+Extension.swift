//
//  UITableView+Extension.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import UIKit
extension UITableView {
    // register for the cells that are created with a Nib.
    func register<T: UITableViewCell>(_ : T.Type) where T: ReusableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.defaultReuseIdentifier, bundle: bundle)
        return register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    // register for the cells that are created from code.
    func registerWithCell<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
}
