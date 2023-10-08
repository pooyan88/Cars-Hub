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
    
    func gotoCarsListViewController(with carsData: [CarsData], delegate: CarsListViewControllerDelegate) {
        let vc: CarsListViewController = CarsListViewController.instantiate(appStoryboard: .main)
        vc.coordinator = self
        vc.carsData = carsData
        vc.delegate = delegate
        navigationController.pushViewController(vc, animated: true)
    }
    
    func popViewController(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }
}
