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
        viewModel.viewWillAppear.onNext(())
    }
    
    private func setupUIElements() {
        view.backgroundColor = .white
        setupTableView()
    }
    
    private func setupBindings() {
        
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
    
    var tableView: UITableView!
    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 64
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            ])
    }
    
    func registerCell() {
        viewModel.tableItemTypes.forEach { [unowned self] in
            $0.registerCell(tableView: self.tableView)
        }
    }
}
