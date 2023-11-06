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
        if DataManager.shared.loadCars() == nil {
            showSearchViewController()
        } else {
            showUserCarListViewController()
        }
    }
    
     func showSearchViewController() {
        let searchVC = SearchViewController.instantiate(appStoryboard: .main)
        searchVC.coordinator = self
        navigationController.setViewControllers([searchVC], animated: true)
    }
    
     func showUserCarListViewController() {
        let carListVC = UserCarsListViewController.instantiate(appStoryboard: .main)
        carListVC.coordinator = self
        navigationController.setViewControllers([carListVC], animated: true)
    }
    
    func gotoCarsListViewController(with carsData: [CarData]) {
        let vc: CarsListViewController = CarsListViewController.instantiate(appStoryboard: .main)
        vc.coordinator = self
        vc.carsData = carsData
        navigationController.pushViewController(vc, animated: true)
    }
    
    func gotoCarDashboardViewController(selectedCar: CarData) {
        let vc = CarsDashboardViewController.instantiate(appStoryboard: .main)
        navigationController.pushViewController(vc, animated: true)
        vc.configViewModel(car: selectedCar)
    }
    
    func popViewController(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }
}
