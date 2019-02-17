//
//  Application.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import Foundation
import UIKit

class Application {
    private let window: UIWindow
    lazy var navigation = Navigation(window: self.window, application: self)
    
    init(window: UIWindow) {
        self.window = window
    }
}
