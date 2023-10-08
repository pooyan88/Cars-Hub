//
//  CarsDashboardViewModel.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/9/1402 AP.
//

import Foundation

class CarsDashboardViewModel {
    
    var showLoading:(_ isAnimating: Bool)->()
    var isComponentsEnable:(_ isEnable: Bool)->()
    var isComponentsHidden:(_ isHidden: Bool)->()
    var isTableViewHidden:(_ isHidden: Bool)->()
    var reloadTableView:()->()
    var carsData: [CarsData] = []
    var selectedCars: [CarsData] = [] {
        didSet {
            isComponentsHidden(true)
            reloadTableView()
            setupTableViewHiddenStyle()
        }
    }
    
    init(showLoading: @escaping (_: Bool) -> Void, isComponentsEnable: @escaping (_: Bool) -> Void, isComponentsHidden: @escaping (_: Bool) -> Void, isTableViewHidden:@escaping (_ isHidden: Bool)-> Void, reloadTableView: @escaping () -> Void) {
        self.showLoading = showLoading
        self.isComponentsEnable = isComponentsEnable
        self.isComponentsHidden = isComponentsHidden
        self.isTableViewHidden = isTableViewHidden
        self.reloadTableView = reloadTableView
        
        getCars()
        
    }
}

//MARK: - Actions
extension CarsDashboardViewModel {
    
    private func setupTableViewHiddenStyle() {
        if selectedCars[0].items.isEmpty {
            isTableViewHidden(true)
        } else {
            isTableViewHidden(false)
        }
    }
    
    func getEngineOilDescription(currentMiles: Int, lastOilChangeInMiles: Int)-> String {
        let text = "You have to change your oil at " + CalculateHelper.shared.calculateOilChangeMile(currentMiles: currentMiles, lastOilChangeInMiles: lastOilChangeInMiles, suggestedMiles: selectedCars[0]).description + "miles"
        return text
    }
}

//MARK: - API Calls
extension CarsDashboardViewModel {
    
    func getCars() {
        NetworkRequests.shared.getAllMakes { [weak self] response in
            guard let self else { return }
            showLoading(true)
            isComponentsEnable(true)
            switch response {
            case .success(let data):
                showLoading(false)
                isComponentsEnable(false)
                carsData = data
            case .failure(let error):
                showLoading(false)
                isComponentsEnable(false)
                print("decode error", error.localizedDescription)
            }
        }
    }
}
