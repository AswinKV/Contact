//
//  ContactCellViewModel.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import UIKit
import RxSwift

protocol ContactCellViewModeling: CellRepresentable {
    // Output
    var fullNameText: Observable<String> { get }
    var imageUrl: Observable<URL> { get }
    var identifier: String? { get }
    var isFavourite: Observable<Bool> { get }
}

class ContactCellViewModel: ContactCellViewModeling {
    // Output
    var fullNameText: Observable<String> = Observable.empty()
    var imageUrl: Observable<URL> = Observable.empty()
    lazy var identifier: String? = {
        return model.identifier?.description
    }()
    var isFavourite: Observable<Bool> = Observable.empty()

    let model: Contact
    init(model: Contact) {
        self.model = model
        createObservables()
    }

    private func createObservables() {
        let firstName = model.firstName ?? ""
        let lastName = model.lastName ?? ""
        let fullName = "\(firstName) \(lastName)"

        fullNameText = Observable
            .just(fullName)

        imageUrl = Observable
            .just(model.profilePic)
            .map {Helper.toURL(with: $0)}
            .ignoreNil()

        isFavourite = Observable
            .just(model.favorite)
            .ignoreNil()
    }
}

extension ContactCellViewModel {
    static func registerCell(tableView: UITableView) {
        tableView.registerWithCell(ContactCell.self)
    }

    func cellInstance(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: ContactCell.defaultReuseIdentifier, for: indexPath) as? ContactCell
            else { return UITableViewCell()}
        cell.prepare(with: self)
        return cell
    }
}
