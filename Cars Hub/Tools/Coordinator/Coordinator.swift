//
//  Coordinator.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/5/1402 AP.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    
    func startCoordinator()
}

class MainCoordinator: Coordinator {
    
    var navigationController = UINavigationController()

    func startCoordinator() {
        let initialVC: CarsDashboardViewController = CarsDashboardViewController.instantiate(appStoryboard: .main)
        initialVC.coordinator = self
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.pushViewController(initialVC, animated: false)
    }
    
    func gotoCarsListViewController(with carMakes: [CarMakesResponse.SearchResult]) {
        let vc: CarsListViewController = CarsListViewController.instantiate(appStoryboard: .main)
        vc.coordinator = self
        vc.carMakes = carMakes
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.pushViewController(vc, animated: false)
    }
}
