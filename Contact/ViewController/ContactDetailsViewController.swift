//
//  ContactDetailsViewController.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ContactDetailsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupUIElements()
        setupBindings()
    }
    
    private var viewModel: ContactViewModelling!
    var disposeBag = DisposeBag()
    
    init(viewModel: ContactViewModelling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupUIElements() {
        view.backgroundColor = .white
        setupEmailTextField()
    }
    
    private func setupBindings() {
        viewModel.emailIdText.bind(to: emailLabel.rx.text).disposed(by: disposeBag)
    }
    
    var emailLabel: UILabel!
    private func setupEmailTextField() {
        emailLabel = UILabel()
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.layer.borderWidth = 1
        emailLabel.layer.borderColor = UIColor.black.cgColor
        emailLabel.textAlignment = .center
        view.addSubview(emailLabel)
        
        NSLayoutConstraint.activate([
            emailLabel.heightAnchor.constraint(equalToConstant: 44),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
            ])
    }
}
