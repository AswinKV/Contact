//
//  AppConstants.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

struct AppConstants {
    static let baseURL = "http://gojek-contacts-app.herokuapp.com"
    
    struct Regex {
        static let email = "[_A-Za-z0-9+-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})"
        static let phone = "((?:\\+|00)[17](?: |\\-)?|(?:\\+|00)[1-9]\\d{0,2}(?: |\\-)?|(?:\\+|00)1\\-\\d{3}(?: |\\-)?)?(0\\d|\\([0-9]{3}\\)|[1-9]{0,3})(?:((?: |\\-)[0-9]{2}){4}|((?:[0-9]{2}){4})|((?: |\\-)[0-9]{3}(?: |\\-)[0-9]{4})|([0-9]{7}))"
        static let mobile = "/^(\\+\\d{1,3}[- ]?)?\\d{10}$/"
    }
}
