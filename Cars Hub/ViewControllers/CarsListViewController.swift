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
    var carMakes: [CarMakesResponse.SearchResult] = [] {
        didSet {
            if tableView != nil {
                tableView.reloadData()
            }
        }
    }
    
    var filteredCarMakes: [CarMakesResponse.SearchResult] = [] {
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
        setupNavigationBar()
        view.layer.createGradientLayer(view: view)
    }
    
    private func setupNavigationBar() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.layer.cornerRadius = 10
        searchBar.clipsToBounds = true
        searchBar.searchTextField.backgroundColor = UIColor(hex:"#232248")
    }
    
    private func setupTableView() {
        tableView.register(identifier: CarsTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: - Actions
extension CarsListViewController {
    

}

//MARK: - TableView Functions
extension CarsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCarMakes.isEmpty ? carMakes.count : filteredCarMakes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CarsTableViewCell.identifier, for: indexPath) as! CarsTableViewCell
        cell.setup(data: filteredCarMakes.isEmpty ? carMakes[indexPath.row] : filteredCarMakes[indexPath.row])
        return cell
    }
}

//MARK: - SearchBar Delegate Functions
extension CarsListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCarMakes = carMakes.filter({($0.makeName?.lowercased() ?? "").contains(searchText.lowercased())})
    }
}
