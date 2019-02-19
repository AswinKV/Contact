//
//  RUIIndicator.swift
//  Contact
//
//  Created by Kuliza-148 on 19/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import UIKit

class RUIActivityIndicatorView: UIActivityIndicatorView {

    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        _initRUIActivityIndicatorView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        _initRUIActivityIndicatorView()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        _initRUIActivityIndicatorView()
    }

    fileprivate func _initRUIActivityIndicatorView() {
        self.hidesWhenStopped = true
        self.color = UIColor.white
    }
}
