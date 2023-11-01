//
//  UserCarsListViewController.swift
//  Cars Hub
//
//  Created by Pooyan J on 8/6/1402 AP.
//

import UIKit

class UserCarsListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var carImageView: UIImageView!
    
    var userCarsList: [String] {
        set {
            tableView.reloadData()
        } get {
            getUserCarsList()
        }
    }
    
    var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
}


//MARK: - Setup Views
extension UserCarsListViewController {
    
    private func setupViews() {
        setupTableView()
        view.layer.createGradientLayer(view: view)
        setupCarImageView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addTapped))
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    private func setupCarImageView() {
        carImageView.image = UIImage(named: "car")
        carImageView.alpha = 0.25
        carImageView.backgroundColor = .clear
    }
 
    private func setupCell(carName: String)-> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = carName
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.textLabel?.textColor = .white
        cell.textLabel?.numberOfLines = 0
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - Logic
extension UserCarsListViewController {
    
    private func getUserCarsList() -> [String] {
        return DataManager.shared.loadCars()?.compactMap({$0.fullName}) ?? []
    }
}

//MARK: - Action
extension UserCarsListViewController {
    
     @objc func addTapped() {
         coordinator?.showSearchViewController()
     }
}

//MARK: - TableView Functions
extension UserCarsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userCarsList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = userCarsList[indexPath.row]
        return setupCell(carName: data)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cars = DataManager.shared.loadCars() {
            coordinator?.gotoCarDashboardViewController(selectedCar: cars[indexPath.row])
        }
    }
}
