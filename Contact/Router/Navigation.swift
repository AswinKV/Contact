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
        appear.barTintColor = .white
        appear.tintColor = UIColor.turquoise()
        appear.isTranslucent = false
        navigationController = UINavigationController(rootViewController: self.showHome())
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func showHome() -> UIViewController {
        let repository = UserRepository()
        let viewModel = HomeScreenViewModel(repository: repository)
        let viewController = HomeViewController(viewModel: viewModel)
        viewController.navigationItem.title = DisplayString.Title.contact
        let addButton = UIBarButtonItem(title: DisplayString.Contact.add, style: UIBarButtonItem.Style.done, target: self, action: nil)
        viewController.navigationItem.rightBarButtonItem = addButton

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
        
        viewModel.editContactViewModel.subscribe(onNext: { [unowned self] (viewModel) in
            self.showEditContactDetails(viewModel: viewModel)
        }).disposed(by: viewController.disposeBag)

        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showEditContactDetails(viewModel: EditContactViewModelling) {
        let viewController = EditContactViewController(viewModel: viewModel)
        let doneButton = UIBarButtonItem(title: DisplayString.Contact.done, style: UIBarButtonItem.Style.done, target: self, action: nil)
        let cancelButton = UIBarButtonItem(title: DisplayString.Contact.cancel, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        viewController.navigationItem.rightBarButtonItem = doneButton
        viewController.navigationItem.leftBarButtonItem = cancelButton
        doneButton.rx.tap.bind(to: viewModel.doneTapped).disposed(by: viewController.disposeBag)
        cancelButton.rx.tap.bind(to: viewModel.cancelTapped).disposed(by: viewController.disposeBag)
        let navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController.present(navigationController, animated: true, completion: nil)
        
        viewModel.cancelTapped.subscribe(onNext: {
            viewController.dismiss(animated: true, completion: nil)
        }).disposed(by: viewController.disposeBag)
    }

}
