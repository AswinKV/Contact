
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

class EditContactViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupUIElements()
        setupBindings()
    }
    
    private var viewModel: EditContactViewModelling!
    var disposeBag = DisposeBag()
    
    init(viewModel: EditContactViewModelling) {
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
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailIdText)
            .disposed(by: disposeBag)
    }
    
    var emailTextField: UITextField!
    private func setupEmailTextField() {
        emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.black.cgColor
        emailTextField.textAlignment = .center
        view.addSubview(emailTextField)
        
        NSLayoutConstraint.activate([
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
            ])
    }
}
