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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let gradientLayer = getGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
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
    
    private func setupBindings() {
        viewModel.fullNameText.bind(to: fullNameLabel.rx.text).disposed(by: disposeBag)
        viewModel.imageUrl.subscribe(onNext: { [unowned self] (url) in
            self.profileImageView.kf.setImage(with: url)
        }).disposed(by: disposeBag)
        callActionView.tapped.bind(to: viewModel.callTapped).disposed(by: callActionView.disposeBag)
        viewModel.callWith.subscribe(onNext: { [unowned self] (mobile) in
            self.makeCall(mobile: mobile)
        }).disposed(by: disposeBag)
        
        viewModel.mobileText.subscribe(onNext: { [unowned self] mobile in
            self.setupMobileEditView(mobile: mobile)
        }).disposed(by: disposeBag)

        viewModel.emailText.subscribe(onNext: { [unowned self] email in
            self.setupEmailEditView(email: email)
        }).disposed(by: disposeBag)

    }
    // Mark : Setup views.
    private func setupUIElements() {
        view.backgroundColor = .white
        setupGradientView()
        setupProfileImageView()
        setupFullNameLabel()
        setUpStackView()
        setUpSecondStackView()
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
            gradientView.heightAnchor.constraint(equalToConstant: 335),
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
            profileImageView.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -127),
            profileImageView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 127),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor, constant: 0),
            ])
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 3
        profileImageView.image = UIImage(named: "user")
        profileImageView.contentMode = .scaleAspectFill
    }
    
    private var fullNameLabel: UILabel!
    private func setupFullNameLabel() {
        fullNameLabel = UILabel()
        view.addSubview(fullNameLabel)
        
        NSLayoutConstraint.activate([
            fullNameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor, constant: 0),
            fullNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            ])
        
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.numberOfLines = 0
        fullNameLabel.textAlignment = .left
        fullNameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        fullNameLabel.textColor = UIColor.tundora()
    }


    private var mainStackView: UIStackView!
    private func setUpStackView() {
        mainStackView = UIStackView()
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.distribution = .equalSpacing
        gradientView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 16),
            mainStackView.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -12),
            mainStackView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 44),
            mainStackView.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -44)
            ])
        
        setupContactActionStack()
    }
    
    private var messageActionView: ContactActionView!
    private func setupMessageActionView() {
        messageActionView = ContactActionView()
        messageActionView.prepare(with: UIImage(named: "chat"), and: DisplayString.Contact.message)
    }
    
    private var callActionView: ContactActionView!
    private func setupCallActionView() {
        callActionView = ContactActionView()
        callActionView.prepare(with: UIImage(named: "call"), and: DisplayString.Contact.call)
    }

    private var emailActionView: ContactActionView!
    private func setupEmailActionView() {
        emailActionView = ContactActionView()
        emailActionView.prepare(with: UIImage(named: "mail"), and: DisplayString.Contact.email)
    }

    private var favouriteActionView: ContactActionView!
    private func setupFavouriteActionView() {
        favouriteActionView = ContactActionView()
        favouriteActionView.prepare(with: UIImage(named: "star-outline"), and: DisplayString.Contact.favourite, isHighlighted: false)
    }

    private func setupContactActionStack() {
        setupMessageActionView()
        setupCallActionView()
        setupEmailActionView()
        setupFavouriteActionView()
        mainStackView.addArrangedSubview(messageActionView)
        mainStackView.addArrangedSubview(callActionView)
        mainStackView.addArrangedSubview(emailActionView)
        mainStackView.addArrangedSubview(favouriteActionView)
    }
    
    private var secondStackView: UIStackView!
    private func setUpSecondStackView() {
        secondStackView = UIStackView()
        secondStackView.axis = .vertical
        secondStackView.alignment = .fill
        secondStackView.distribution = .equalSpacing
        view.addSubview(secondStackView)
        secondStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            secondStackView.topAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: 0),
            secondStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            secondStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
            ])
        
    }
    
    private var mobileEditView: ContactEditView!
    private func setupMobileEditView(mobile: String) {
        mobileEditView = ContactEditView()
        mobileEditView.prepare(with: DisplayString.Contact.mobile, and: mobile)
        secondStackView.addArrangedSubview(mobileEditView)
    }

    private var emailEditView: ContactEditView!
    private func setupEmailEditView(email: String) {
        emailEditView = ContactEditView()
        emailEditView.prepare(with: DisplayString.Contact.email, and: email)
        secondStackView.addArrangedSubview(emailEditView)
    }
    
//    Mark:- setup contact actions.
    private func makeCall(mobile: String) {
        Helper.makeCall(toNumber: mobile)
    }
}
