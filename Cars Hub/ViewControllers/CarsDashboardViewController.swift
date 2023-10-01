//
//  ViewController.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/5/1402 AP.
//

import UIKit

class CarsDashboardViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBAction func searchButtonAction(_ sender: Any) {
        coordinator?.gotoCarsListViewController(with: carMakes)
    }
    
    var coordinator: MainCoordinator?
    var carMakes: [CarMakesResponse.SearchResult] {
        set {
            DataManager.shared.saveCars(data: newValue)
        } get {
            DataManager.shared.loadCars()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        getData()
    }
}

//MARK: - Setup Functions
extension CarsDashboardViewController {
    
    private func setupViews() {
        setupSearchButton()
        setupDescriptionLabel()
        view.layer.createGradientLayer(view: view)
    }
    
    private func setupSearchButton() {
        searchButton.tintColor = .white
        searchButton.setTitle("Search", for: .normal)
        searchButton.backgroundColor = .searchButtonColor
        searchButton.layer.cornerRadius = 10
    }
    
    private func setupDescriptionLabel() {
        let originalFont = UIFont.systemFont(ofSize: 20.0)
        let boldFont = originalFont.bold(withSize: 20.0)
        descriptionLabel.font = boldFont
        descriptionLabel.text = "Add Your Car"
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
    }
}

//MARK: - Actions
extension CarsDashboardViewController {
    
    func getData() {
        if carMakes.isEmpty {
            getAllMakes()
        }
    }
}

//MARK: - API Calls
extension CarsDashboardViewController {
    
    func getAllMakes() {
        NetworkRequests.shared.getAllMakes { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                carMakes = data.results
            case .failure:
                showNetworkError(error: .decodeError)
            }
        }
    }
}
