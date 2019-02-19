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
import MessageUI

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
        emailActionView.tapped.bind(to: viewModel.emailTapped).disposed(by: emailActionView.disposeBag)
        messageActionView.tapped.bind(to: viewModel.messageTapped).disposed(by: messageActionView.disposeBag)

        viewModel.callWith.subscribe(onNext: { [unowned self] (mobile) in
            self.makeCall(mobile: mobile)
        }).disposed(by: disposeBag)
        
        viewModel.emailWith.subscribe(onNext: { [unowned self] (email) in
            self.sendEmail(email: email)
        }).disposed(by: disposeBag)
        
        viewModel.messageWith.subscribe(onNext: { [unowned self] (message) in
            self.sendText(phoneNumber: message)
        }).disposed(by: disposeBag)
        
        viewModel.mobileText.subscribe(onNext: { [unowned self] mobile in
            self.setupMobileEditView(mobile: mobile)
        }).disposed(by: disposeBag)

        viewModel.emailText.subscribe(onNext: { [unowned self] email in
            self.setupEmailEditView(email: email)
        }).disposed(by: disposeBag)
        
        viewModel.contactUpdated.subscribe(onNext: {[unowned self] contact in
                self.favouriteActionView.removeFromSuperview()
                if let favourite = contact.favorite {
                    self.setupFavouriteActionView(isHighlighted: favourite)
                    self.favouriteActionView.tapped.map { !favourite }
                        .bind(to: self.viewModel.favouriteTapped)
                        .disposed(by: self.favouriteActionView.disposeBag)
                }
        }).disposed(by: disposeBag)

        viewModel.favourite.subscribe(onNext: {[unowned self] favourite in
                self.favouriteActionView.removeFromSuperview()
                self.setupFavouriteActionView(isHighlighted: favourite)
                self.favouriteActionView.tapped.map { !favourite }
                    .bind(to: self.viewModel.favouriteTapped)
                    .disposed(by: self.favouriteActionView.disposeBag)
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
        mainStackView.addArrangedSubview(messageActionView)
    }
    
    private var callActionView: ContactActionView!
    private func setupCallActionView() {
        callActionView = ContactActionView()
        callActionView.prepare(with: UIImage(named: "call"), and: DisplayString.Contact.call)
        mainStackView.addArrangedSubview(callActionView)
    }

    private var emailActionView: ContactActionView!
    private func setupEmailActionView() {
        emailActionView = ContactActionView()
        emailActionView.prepare(with: UIImage(named: "mail"), and: DisplayString.Contact.email)
        mainStackView.addArrangedSubview(emailActionView)
    }

    private var favouriteActionView: ContactActionView!
    private func setupFavouriteActionView(isHighlighted: Bool) {
        favouriteActionView = ContactActionView()
        favouriteActionView.prepare(with: UIImage(named: "star-outline"), and: DisplayString.Contact.favourite, isHighlighted: isHighlighted)
        mainStackView.addArrangedSubview(favouriteActionView)
    }

    private func setupContactActionStack() {
        setupMessageActionView()
        setupCallActionView()
        setupEmailActionView()
        setupFavouriteActionView(isHighlighted: false)
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
        mobileEditView.prepare(with: DisplayString.Contact.mobile, and: mobile, keyboardType: .phonePad)
        secondStackView.addArrangedSubview(mobileEditView)
    }

    private var emailEditView: ContactEditView!
    private func setupEmailEditView(email: String) {
        emailEditView = ContactEditView()
        emailEditView.prepare(with: DisplayString.Contact.email, and: email, keyboardType: .emailAddress)
        secondStackView.addArrangedSubview(emailEditView)
    }
    
//    Mark:- setup contact actions.
    private func makeCall(mobile: String) {
        Helper.makeCall(toNumber: mobile)
    }
    
    private func sendEmail(email: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            Helper.showAlert(message: DisplayString.Contact.mailNotAvailable)
            print("log to crash logging ->")
        }
    }
    
    private func sendText(phoneNumber: String) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.recipients = [phoneNumber]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        } else {
            Helper.showAlert(message: DisplayString.Contact.smsNotAvailable)
        }
    }
}

extension ContactDetailsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension ContactDetailsViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}
