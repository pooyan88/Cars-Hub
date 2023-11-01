//
//  SearchViewController.swift
//  Cars Hub
//
//  Created by Pooyan J on 8/7/1402 AP.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBAction func searchButtonAction(_ sender: Any) {
        coordinator?.gotoCarsListViewController(with: carsData)
    }
    
    var carsData: [CarData] = []
    var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        getCars()
    }
}

//MARK: - Setup Views
extension SearchViewController {
    
    private func setupViews() {
        view.layer.createGradientLayer(view: view)
        setupDescriptionLabel()
        setupSearchButton()
        setupCarImageView()
    }
    
    private func setupDescriptionLabel() {
        let originalFont = UIFont.systemFont(ofSize: 20.0)
        let boldFont = originalFont.bold(withSize: 20.0)
        descriptionLabel.font = boldFont
        descriptionLabel.text = "Add Your Car"
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
    }
    
    private func setupSearchButton() {
        searchButton.tintColor = .white
        searchButton.setTitle("Search", for: .normal)
        searchButton.backgroundColor = .searchButtonColor
        searchButton.layer.cornerRadius = 10
    }
    
    private func setupCarImageView() {
        carImageView.image = UIImage(named: "car")
        carImageView.alpha = 0.25
        carImageView.backgroundColor = .clear
    }
    
    private func setupLoadingIndicator(isAnimating: Bool) {
        isAnimating ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
}

//MARK: - Action
extension SearchViewController {
}

//MARK: - API Calls
extension SearchViewController {
    
    private func getCars() {
        getAllMakers { [weak self] cars in
            self?.carsData = cars
        }
    }
    
    private func getAllMakers(completions: @escaping ([CarData])-> Void) {
        setupLoadingIndicator(isAnimating: true)
        searchButton.isEnabled = false
        NetworkRequests.shared.getAllMakes { [weak self] response in
            DispatchQueue.main.async {
            self?.setupLoadingIndicator(isAnimating: false)
            guard let self else { return }
                switch response {
                case .success(let data):
                    self.searchButton.isEnabled = true
                    completions(data)
                case .failure(let error):
                    completions([])
                    print("decode error", error.localizedDescription)
                }
            }
        }
    }
}
