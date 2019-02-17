//
//  Navigation.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import Foundation
import UIKit

final class Navigation {
    var navigationController: UINavigationController
    let application: Application
    
    init(window: UIWindow, application: Application) {
        self.application = application
        self.navigationController = UINavigationController()
        let appear = UINavigationBar.appearance()
        appear.barTintColor = .blue
        appear.isTranslucent = false
        navigationController = UINavigationController(rootViewController: self.showHome())
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func showHome() -> UIViewController {
        let repository = UserRepository()
        let viewModel = HomeScreenViewModel(repository: repository)
        let viewController = HomeViewController(viewModel: viewModel)
        
        viewModel.contactDetails.subscribe(onNext: { [unowned self] (contactDetail) in
            self.showContactDetails(model: contactDetail)
        }).disposed(by: viewController.disposeBag)
        
        return viewController
    }
    
    private func showContactDetails(model: ContactDetail) {
        let viewModel = ContactViewModel(model: model)
        let viewController = ContactDetailsViewController(viewModel: viewModel)
        let editButton = UIBarButtonItem(title: DisplayString.Contact.edit, style: UIBarButtonItem.Style.done, target: self, action: nil)
        viewController.navigationItem.rightBarButtonItem = editButton
        editButton.rx.tap.bind(to: viewModel.editTapped).disposed(by: viewController.disposeBag)
        navigationController.pushViewController(viewController, animated: true)
    }
}
