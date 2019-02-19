//
//  ContactActionView.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import UIKit
import RxSwift

class ContactActionView: UIView {
    private var button: UIButton!
    private var label: UILabel!
    let disposeBag = DisposeBag()
    var tapped: PublishSubject<Void> = PublishSubject()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addViews()
    }

    func prepare(with image: UIImage?,and title: String, isHighlighted: Bool = true) {
        label.text = title
        button.setImage(image, for: UIControl.State.normal)
        button.backgroundColor = isHighlighted ? UIColor.turquoise() : .white
        button.rx.tap.bind(to: tapped).disposed(by: disposeBag)
    }

    private func addViews() {
        setupButton()
        setupLabel()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        button.layer.cornerRadius = button.bounds.width / 2
    }

    private func setupButton() {
        button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.turquoise()
        button.tintColor = .white
        button.layer.masksToBounds = true
        addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            button.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44)
            ])

    }

    private func setupLabel() {
        label = UILabel()
        addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: button.centerXAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
            ])

        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
    }
}
