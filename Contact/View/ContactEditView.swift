//
//  ContactActionView.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import UIKit
import RxSwift

class ContactEditView: UIView {
    private var textField: UITextField!
    private var label: UILabel!
    let disposeBag = DisposeBag()
    let text = PublishSubject<String>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addViews()
    }

    func prepare(with title: String,and value: String, isEditable: Bool = false, keyboardType: UIKeyboardType) {
        label.text = title
        textField.text = value
        textField.isUserInteractionEnabled = isEditable
        textField.keyboardType = keyboardType
    }

    private func addViews() {
        setupTextfield()
        setupLabel()
        setupThinLine()
        textField.rx.text.orEmpty.bind(to: text).disposed(by: disposeBag)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func setupTextfield() {
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .left
        textField.textColor = UIColor.tundora()
        textField.font = .systemFont(ofSize: 16)
        addSubview(textField)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
            ])
    }

    private func setupLabel() {
        label = UILabel()
        addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            label.widthAnchor.constraint(equalToConstant: 100),
            label.trailingAnchor.constraint(equalTo: textField.leadingAnchor, constant: -32)
            ])

        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor.tundora().withAlphaComponent(0.5)
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
    }

    private func setupThinLine() {
        let view = UIView()
        view.backgroundColor = UIColor.tundora().withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            view.heightAnchor.constraint(equalToConstant: 1),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
            ])
    }
}
