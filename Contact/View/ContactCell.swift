//
//  ContactCell.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher
class ContactCell: UITableViewCell, ReusableView {
    private var fullNameLabel: UILabel!
    private var profileImageView: UIImageView!
    private var disposeBag: DisposeBag!
    
    private var viewModel: ContactCellViewModeling! {
        didSet {
            setupBinding()
        }
    }
    
    func prepare(with viewModel: ContactCellViewModeling) {
        self.viewModel = viewModel
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func prepareForReuse() {
        viewModel = nil
        disposeBag = nil
    }
    
    private func setup() {
        self.clipsToBounds = true
        self.backgroundColor = .clear
        setupFullNameLabel()
        setupProfileImageView()
    }
    
    private func setupBinding() {
        guard let viewModel = viewModel else { return }
        let bag = DisposeBag()
        
        viewModel.fullNameText
            .bind(to: fullNameLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.imageUrl.subscribe(onNext: { [weak self] (url) in
            self?.profileImageView.kf.setImage(with: url)
        }).disposed(by: bag)
        
        self.disposeBag = bag
    }
    
    private func setupFullNameLabel() {
        fullNameLabel = UILabel()
        self.contentView.addSubview(fullNameLabel)
        
        NSLayoutConstraint.activate([
            self.fullNameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            self.fullNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 24),
            self.fullNameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -24),
            self.fullNameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0),
            ])
        
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.numberOfLines = 0
        fullNameLabel.textAlignment = .left
        fullNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        fullNameLabel.textColor = UIColor.tundora()
    }
    
    private func setupProfileImageView() {
        profileImageView = UIImageView()
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
        self.contentView.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            self.profileImageView.trailingAnchor.constraint(equalTo: self.fullNameLabel.leadingAnchor, constant: -16),
            self.profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.profileImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0),
            self.profileImageView.widthAnchor.constraint(equalToConstant: 40),
            self.profileImageView.heightAnchor.constraint(equalToConstant: 40),
            ])
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
    }
}
