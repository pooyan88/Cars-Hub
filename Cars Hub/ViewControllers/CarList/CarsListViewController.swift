//
//  CarsListViewController.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/8/1402 AP.
//

import UIKit

class CarsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var coordinator: MainCoordinator?
    var carsData: [CarData] = [] {
        didSet {
            if tableView != nil {
                tableView.reloadData()
            }
        }
    }
    
    var filteredCarMakes: [CarData] = [] {
        didSet {
            if tableView != nil {
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
}

//MARK: - Setup Views
extension CarsListViewController {
    
    private func setupView() {
        setupTableView()
        view.layer.createGradientLayer(view: view)
        navigationItem.largeTitleDisplayMode = .never
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.white
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.layer.cornerRadius = 10
        searchBar.clipsToBounds = true
        searchBar.searchTextField.textColor = .white
    }
    
    private func setupTableView() {
        tableView.register(identifier: CarsTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: - TableView Functions
extension CarsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCarMakes.isEmpty ? carsData.count : filteredCarMakes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CarsTableViewCell.identifier, for: indexPath) as! CarsTableViewCell
        cell.setup(data: filteredCarMakes.isEmpty ? carsData[indexPath.row] : filteredCarMakes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.gotoCarDashboardViewController(selectedCar: carsData[indexPath.row])
    }
}

//MARK: - SearchBar Delegate Functions
extension CarsListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCarMakes = carsData.filter({($0.companyName?.lowercased() ?? "" + "-" + ($0.carName?.lowercased() ?? "?")).contains(searchText.lowercased())})
    }
}
