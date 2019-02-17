//
//  HomeViewController.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupUIElements()
        registerCell()
        setupBindings()
    }
    
    private var viewModel: HomeScreenViewModelling!
    let disposeBag = DisposeBag()
    
    init(viewModel: HomeScreenViewModelling) {
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
        setupTableView()
        setupSubmitButton()
    }
    
    private func setupBindings() {
        submitButton.rx.tap
            .bind(to: viewModel.submitButtonClicked)
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<CustomSection>(configureCell: {(_, tableView, indexPath, item)
            in
            return item.cellInstance(tableView: tableView, indexPath: indexPath)
        })
        
        viewModel.tableItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ContactCellViewModeling.self)
            .bind(to: viewModel.cellSelected)
            .disposed(by: disposeBag)
    }
    
    var submitButton: UIButton!
    private func setupSubmitButton() {
        submitButton = UIButton()
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            submitButton.widthAnchor.constraint(equalToConstant: 120),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
            ])
        submitButton.setTitle("Submit", for: .normal)
        submitButton.titleLabel?.font = .boldSystemFont(ofSize: 24)
        submitButton.backgroundColor = .black
        
    }
    
    var tableView: UITableView!
    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            ])
        tableView.rowHeight = 100
    }
    
    func registerCell() {
        viewModel.tableItemTypes.forEach { [unowned self] in
            $0.registerCell(tableView: self.tableView)
        }
    }
}
