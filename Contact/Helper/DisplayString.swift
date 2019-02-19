//
//  DisplayString.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import Foundation

struct DisplayString {
    
    struct Contact {
        static let edit = NSLocalizedString("edit", comment: "edit button text in contact details screen.")
        static let done = NSLocalizedString("done", comment: "done button text in edit contact screen.")
        static let add = NSLocalizedString("add", comment: "add plus icon in home screen.")
        static let message = NSLocalizedString("message", comment: "message text in contact details screen.")
        static let call = NSLocalizedString("call", comment: "call text in contact details screen.")
        static let email = NSLocalizedString("email", comment: "email text in contact details screen.")
        static let favourite = NSLocalizedString("favourite", comment: "favourite text in contact details screen.")
        static let mobile = NSLocalizedString("mobile", comment: "mobile text in contact details screen.")
        static let firstName = NSLocalizedString("firstName", comment: "first name text in edit contact screen.")
        static let lastName = NSLocalizedString("lastName", comment: "last name text in edit contact screen.")
        static let save = NSLocalizedString("save", comment: "save button text in add contact screen.")
        static let favourited = NSLocalizedString("favourited", comment: "")
        static let unfavourited = NSLocalizedString("unfavourited", comment: "")
        static let smsNotAvailable = NSLocalizedString("smsNotAvailable", comment: "SMS services are not available")
        static let mailNotAvailable = NSLocalizedString("mailNotAvailable", comment: "Mail services are not available")
    }
    
    struct Validation {
        static let invalidPhone = NSLocalizedString("invalidPhone", comment: "")
        static let invalidName = NSLocalizedString("invalidName", comment: "")
        static let invalidEmail = NSLocalizedString("invalidEmail", comment: "")
    }
    
    struct General {
        static let ok = NSLocalizedString("ok", comment: "")
        static let cancel = NSLocalizedString("cancel", comment: "cancel button text in edit contact screen.")
        static let camera = NSLocalizedString("camera", comment: "save button text in add contact screen.")
        static let album = NSLocalizedString("album", comment: "save button text in add contact screen.")
    }
    
    struct Title {
        static let contact = NSLocalizedString("contact", comment: "home screen title.")
    }
}
