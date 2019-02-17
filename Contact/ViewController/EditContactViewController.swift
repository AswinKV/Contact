
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
    
    private func setupBindings() {
        viewModel.mobileText.subscribe(onNext: { [unowned self] mobile in
            self.setupMobileEditView(mobile: mobile)
        }).disposed(by: disposeBag)
        
        viewModel.emailText.subscribe(onNext: { [unowned self] email in
            self.setupEmailEditView(email: email)
        }).disposed(by: disposeBag)
        
        viewModel.firstNameText.subscribe(onNext: { [unowned self] name in
            self.setupFirstNameEditView(name: name)
        }).disposed(by: disposeBag)
        
        viewModel.lastNameText.subscribe(onNext: { [unowned self] name in
            self.setupLastNameEditView(name: name)
        }).disposed(by: disposeBag)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let gradientLayer = getGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
    }
    
    private func setupUIElements() {
        view.backgroundColor = .white
        setupGradientView()
        setupProfileImageView()
        setUpStackView()
    }
    private var gradientView: UIView!
    private func setupGradientView() {
        gradientView = UIView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gradientView)
        
        NSLayoutConstraint.activate([
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            gradientView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            gradientView.heightAnchor.constraint(equalToConstant: 250)
            ])
    }
    
    private func getGradientLayer() -> CAGradientLayer {
        let colorTop = UIColor.white.cgColor
        let colorBottom = UIColor.turquoise().cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.opacity = 0.55
        return gradientLayer
    }
    
    private var profileImageView: UIImageView!
    private func setupProfileImageView() {
        profileImageView = UIImageView()
        view.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 150),
            profileImageView.centerXAnchor.constraint(equalTo: gradientView.centerXAnchor, constant: 0),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor, constant: 0),
            profileImageView.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -18),
            ])
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 3
        profileImageView.image = UIImage(named: "user")
        profileImageView.contentMode = .center
    }

    private var mainStackView: UIStackView!
    private func setUpStackView() {
        mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.distribution = .equalSpacing
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: 0),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
            ])
    }

    private var mobileEditView: ContactEditView!
    private func setupMobileEditView(mobile: String) {
        mobileEditView = ContactEditView()
        mobileEditView.prepare(with: DisplayString.Contact.mobile, and: mobile, isEditable: true)
        mainStackView.addArrangedSubview(mobileEditView)
    }
    
    private var emailEditView: ContactEditView!
    private func setupEmailEditView(email: String) {
        emailEditView = ContactEditView()
        emailEditView.prepare(with: DisplayString.Contact.email, and: email, isEditable: true)
        mainStackView.addArrangedSubview(emailEditView)
    }

    private var firstNameEditView: ContactEditView!
    private func setupFirstNameEditView(name: String) {
        firstNameEditView = ContactEditView()
        firstNameEditView.prepare(with: DisplayString.Contact.firstName, and: name, isEditable: true)
        mainStackView.addArrangedSubview(firstNameEditView)
    }
    
    private var lastNameEditView: ContactEditView!
    private func setupLastNameEditView(name: String) {
        lastNameEditView = ContactEditView()
        lastNameEditView.prepare(with: DisplayString.Contact.lastName, and: name, isEditable: true)
        mainStackView.addArrangedSubview(lastNameEditView)
    }
}
