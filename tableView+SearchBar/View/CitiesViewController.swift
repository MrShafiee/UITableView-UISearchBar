//
//  CitiesViewController.swift
//  tableView+SearchBar
//
//  Created by Amin Shafiee on 11/7/1397 AP.
//  Copyright © 1397 amin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CitiesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let viewModel = CitiesViewModel()
    private let disposeBag = DisposeBag()
    var rows = PublishSubject<[CityModel]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        bindViewModel()
        viewModel.setDataSoruce()
    }
    
    func setupTableView(){
        tableView.allowsSelection = true
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "CityTableViewCell")
    }
    
    func bindViewModel(){
        
        viewModel.tableRowsItem.bind(to: rows).disposed(by: disposeBag)
        
        let query = searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
        
        
        Observable.combineLatest(rows, query) { [unowned self] (allItem, query) -> [CityModel] in
            return self.filteredCities(with: allItem, query: query)
            }
            .bind(to: tableView.rx.items(cellIdentifier: "CityTableViewCell", cellType: CityTableViewCell.self)) {
             (row,item,cell) in
                cell.CityNameLbl.text = item.name
            }.disposed(by: disposeBag)
        
        
        
        tableView.rx.modelSelected(CityModel.self).subscribe(onNext: { selectedCity in
            print("selected city is \(selectedCity.name)")
        }).disposed(by: disposeBag)
        
        
        tableView.rx.itemSelected.subscribe(onNext:{ indexPath in
            print("selected index is \(indexPath.row)")
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(
            tableView.rx.modelSelected(CityModel.self),
            tableView.rx.itemSelected ).subscribe(onNext: { (selectedCity, indexPath) in
                print("1 selected City is \(selectedCity) and indexPath is \(indexPath.row)")
            }).disposed(by: disposeBag)
        
        Observable.zip(
            tableView.rx.modelSelected(CityModel.self),
            tableView.rx.itemSelected ).subscribe(onNext: { (selectedCity, indexPath) in
                print("2 selected City is \(selectedCity) and indexPath is \(indexPath.row)")
            }).disposed(by: disposeBag)
        
    }
    
    func filteredCities(with allCities: [CityModel], query: String) -> [CityModel] {
        guard !query.isEmpty else { return allCities }
        
        let filteredCities = allCities.filter{ $0.name.hasPrefix(query) }
        return filteredCities
    }
    
}
