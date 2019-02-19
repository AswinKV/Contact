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
    private var favouriteImageView: UIImageView!
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
        self.selectionStyle = .none
        setupFullNameLabel()
        setupProfileImageView()
        setupFavouriteImageView()
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

        viewModel.isFavourite.subscribe(onNext: { [weak self] (isFavourite) in
            self?.favouriteImageView.isHidden = !isFavourite
        }).disposed(by: bag)

        self.disposeBag = bag
    }

    private func setupFullNameLabel() {
        fullNameLabel = UILabel()
        self.contentView.addSubview(fullNameLabel)

        NSLayoutConstraint.activate([
            fullNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            fullNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            fullNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0)
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
        contentView.addSubview(profileImageView)

        NSLayoutConstraint.activate([
            profileImageView.trailingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor, constant: -16),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40)
            ])

        profileImageView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupFavouriteImageView() {
        favouriteImageView = UIImageView()
        favouriteImageView.image = UIImage(named: "favourite")
        contentView.addSubview(favouriteImageView)

        NSLayoutConstraint.activate([
            favouriteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            favouriteImageView.leadingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor, constant: 16),
            favouriteImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            favouriteImageView.widthAnchor.constraint(equalToConstant: 16),
            favouriteImageView.heightAnchor.constraint(equalToConstant: 16)
            ])

        favouriteImageView.translatesAutoresizingMaskIntoConstraints = false
        favouriteImageView.isHidden = true
    }
}
