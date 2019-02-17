//
//  Helper.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import Foundation
import UIKit

struct Helper {
    static func getCachesDirectory() -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func showAlert(withTitle title: String = "",
                          message: String,
                          actionTitle: String = DisplayString.General.ok,
                          actionHandler: ((UIAlertAction) -> Void)? = nil ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: actionTitle, style: .default, handler: actionHandler)
        alertController.addAction(okayAction)
        alertController.show()
    }
    
    static func verifyUrl(urlString: String) -> Bool {
        guard let url = URL(string: urlString) else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
    static func toURL(with urlString: String?) -> URL? {
        guard let urlString = urlString else { return nil }
        switch Helper.verifyUrl(urlString: urlString) {
        case true:
            return URL(string: urlString)
        case false:
            return URL(string: AppConstants.baseURL + urlString)
        }
    }
}
