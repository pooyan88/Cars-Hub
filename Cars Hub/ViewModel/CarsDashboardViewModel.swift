//
//  CarsDashboardViewModel.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/8/1402 AP.
//

import Foundation

class CarsDashboardViewModel {
    
    var cars: [CarMakesResponse.SearchResult] = []
    
    init() {
        getAllMakes()
    }
    
}

//MARK: - Actions
extension CarsDashboardViewModel {
    
}

//MARK: - API Calls
extension CarsDashboardViewModel {
    
    func getAllMakes() {
        NetworkRequests.shared.getAllMakes { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                cars = data.results
            case .failure:
                print("Error")
            }
        }
    }
}
