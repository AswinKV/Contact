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
                          actionTitle: String = "Ok",
                          actionHandler: ((UIAlertAction) -> Void)? = nil ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: actionTitle, style: .default, handler: actionHandler)
        alertController.addAction(okayAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
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
    
    static func makeCall(toNumber: String) {
        let number = toNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    static func showIndicator() {
        UIApplication.shared.keyWindow?.addSubview(activityIndicatorCoverView)
        UIApplication.shared.keyWindow?.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
    }
    
    static func hideIndicator() {
        activityIndicatorCoverView.removeFromSuperview()
        activityIndicatorView.removeFromSuperview()
        activityIndicatorView.stopAnimating()
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
    }
}
