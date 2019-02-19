
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

class AddContactViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupUIElements()
        setupBindings()
    }
    
    private var viewModel: AddContactViewModelling!
    var disposeBag = DisposeBag()
    
    init(viewModel: AddContactViewModelling) {
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
        viewModel.uploadTapped.subscribe(onNext: { [unowned self] () in
            self.showUploadAlert()
        }).disposed(by: disposeBag)
        
        viewModel.errorObservable.subscribe(onNext: { (text) in
            guard let message = text else { return }
            Helper.showAlert(message: message)
        }).disposed(by: disposeBag)
        
        mobileEditView.text.bind(to: viewModel.mobileString).disposed(by: mobileEditView.disposeBag)
        emailEditView.text.bind(to: viewModel.emailString).disposed(by: emailEditView.disposeBag)
        firstNameEditView.text.bind(to: viewModel.firstNameString).disposed(by: firstNameEditView.disposeBag)
        lastNameEditView.text.bind(to: viewModel.lastNameString).disposed(by: lastNameEditView.disposeBag)
        uploadButton.rx.tap.bind(to: viewModel.uploadTapped).disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        // Fix me :- duplicate gradient layer addition.
        
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
        setupTextFields()
    }
    
    private func setupTextFields() {
        setupMobileEditView(mobile: "")
        setupEmailEditView(email: "")
        setupFirstNameEditView(name: "")
        setupLastNameEditView(name: "")
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
        setupUploadButton()
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
    
    var uploadButton: UIButton!
    private func setupUploadButton() {
        uploadButton = UIButton()
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(uploadButton)
        
        NSLayoutConstraint.activate([
            uploadButton.heightAnchor.constraint(equalToConstant: 60),
            uploadButton.widthAnchor.constraint(equalToConstant: 60),
            uploadButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 0),
            uploadButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 0)
            ])
        
        uploadButton.backgroundColor = .white
        uploadButton.tintColor = UIColor.turquoise()
        uploadButton.setImage(UIImage(named: "camera"), for: UIControl.State.normal)
        uploadButton.layer.cornerRadius = 30
        uploadButton.layer.masksToBounds = true
        uploadButton.contentMode = .scaleAspectFit
    }
    
    private func showUploadAlert() {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
}

extension AddContactViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
}

