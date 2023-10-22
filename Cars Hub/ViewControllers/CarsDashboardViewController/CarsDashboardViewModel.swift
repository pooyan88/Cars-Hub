//
//  CarsDashboardViewModel.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/9/1402 AP.
//

import Foundation

class CarsDashboardViewModel {
    
    private var showLoading: (_ isAnimating: Bool)-> Void
    private var isComponentsEnable: (_ isEnable: Bool)-> Void
    private var isComponentsHidden: (_ isHidden: Bool)-> Void
    private var isTableViewHidden: (_ isHidden: Bool)-> Void
    private var reloadTableView: ()-> Void
    private var updateTimingBeltReplacement: (_ text: String)-> Void
    private var updateEngineOilMilageText: (_ text: String)-> Void
    private var showBanner: (_ text: String)-> Void
    var timeBeltText = ""
    var engineOilMilageText = ""
    var currentMilageText = "" {
        didSet {
            if timeBeltText.count > currentMilageText.count {
                showErrorBanner(error: "Milage has to be greater than last service")
            }
        }
    }
    var carsData: [CarsData] = []
    var selectedCars: [CarsData] = [] {
        didSet {
            isComponentsHidden(true)
            reloadTableView()
            setupTableViewHiddenStyle()
        }
    }
    var currentMiles: Int {
        return Int(currentMilageText) ?? 0
    }
    
    init(showLoading: @escaping (_: Bool) -> Void,
         isComponentsEnable: @escaping (_: Bool) -> Void,
         isComponentsHidden: @escaping (_: Bool) -> Void,
         isTableViewHidden:@escaping (_ isHidden: Bool)-> Void,
         reloadTableView: @escaping () -> Void,
         updateTimingBeltReplacement: @escaping (_ text: String)-> Void,
         updateEngineOilMilageText: @escaping (_ text: String)-> Void,
         showBanner: @escaping (_ text: String)-> Void) {
        self.showLoading = showLoading
        self.isComponentsEnable = isComponentsEnable
        self.isComponentsHidden = isComponentsHidden
        self.isTableViewHidden = isTableViewHidden
        self.reloadTableView = reloadTableView
        self.updateTimingBeltReplacement = updateTimingBeltReplacement
        self.updateEngineOilMilageText = updateEngineOilMilageText
        self.showBanner = showBanner
        getCars()
        
    }
}


//MARK: - Logic
extension CarsDashboardViewModel {
    
    private func getTimeBeltDescription() -> String {
        if isTimeBeltFieldValid() {
            return getTimingBeltReplacementDescription(currentMiles: currentMiles, lastOilChangeInMiles: Int(timeBeltText) ?? 0)
        }
        return "?"
    }
    
    private func getEngineOilDescription()-> String {
        if engineOilMilageText.count >= 0 {
            return getEngineOilDescription(currentMiles: currentMiles, lastOilChangeInMiles: Int(engineOilMilageText) ?? 0)
        }
        return "?"
    }
    
    private func isAllFieldsValid() -> Bool {
        return isTimeBeltFieldValid() || isEngineOilFieldValid() 
    }
    
    private func isTimeBeltFieldValid()-> Bool {
        return timeBeltText.count >= 3
    }
    
    private func isEngineOilFieldValid()-> Bool {
        return engineOilMilageText.count >= 3
    }
    
    private func showErrorBanner(error: String) {
        if !isTimeBeltFieldValid() {
            showBanner(error)
        }
    }
}

//MARK: - Actions
extension CarsDashboardViewModel {
    
    func updateSummaryLabel() {
        if isAllFieldsValid() {
            updateTimingBeltReplacement(getTimeBeltDescription())
            updateEngineOilMilageText(getEngineOilDescription())
        } else {
            showErrorBanner(error: "enter at least 3 characters")
        }
        //        updateLabelsWhenTextFieldsAreEmpty(textField: textField)
        //        updateEngineOilHelperLabel()
        //        updateTransmissionOilHelperLabel()
        //        updateFiltersReplacementHelper()
    }
    
    private func setupTableViewHiddenStyle() {
        if selectedCars.first?.items.isEmpty ?? true {
            isTableViewHidden(true)
        } else {
            isTableViewHidden(false)
        }
    }
    
    func getEngineOilDescription(currentMiles: Int, lastOilChangeInMiles: Int)-> String {
        let text = "You have to change your oil at " + CalculateHelper.shared.calculateOilChangeMile(currentMiles: currentMiles, lastOilChangeInMiles: lastOilChangeInMiles, suggestedMiles: selectedCars[0]).description + "miles"
        return text
    }
    
    func getTransmissionOilDescription(currentMiles: Int, lastOilChangeInMiles: Int)-> String {
        let text = "You have to change your Transmission oil at " + CalculateHelper.shared.calculateTransmissionOilChangeInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastOilChangeInMiles, suggestedMiles: selectedCars[0]).description + "miles"
        return text
    }
    
    func getTimingBeltReplacementDescription(currentMiles: Int, lastOilChangeInMiles: Int)-> String {
        if currentMiles == 0 {
            return 0.description
        } else {
            let int = CalculateHelper.shared.calculateTimingBeltReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastOilChangeInMiles, suggestedMiles: selectedCars[0])
            if int == 0 {
                return "Your timing belt is long life"
            } else {
                return "You have to replace your timing belt at " + int.description + "miles"
            }
        }
    }
    
    func getNextServiceDescription(currentMiles: Int, lastOIlChangeInMiles: Int)-> String {
        let oilFilterReplacementMilage = CalculateHelper.shared.calculateOilFilterReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastOIlChangeInMiles, suggestedMiles: selectedCars[0])
        let intakeFilterReplacementMilage = CalculateHelper.shared.calculateIntakeFilterReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastOIlChangeInMiles, suggestedMiles: selectedCars[0])
        let cabinFilterReplacementMilage = CalculateHelper.shared.calculateCabinFilterReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastOIlChangeInMiles, suggestedMiles: selectedCars[0])
        let coolantChangeInMiles = CalculateHelper.shared.calculateCoolantChangeInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastOIlChangeInMiles, suggestedMiles: selectedCars[0])
        let breakingOilChangeInMiles = CalculateHelper.shared.calculateBreakingOilChangeInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastOIlChangeInMiles, suggestedMiles: selectedCars[0])
        let text = "Engine oil replace mile: " + oilFilterReplacementMilage.description + "\r\n"
        + " intake filter replace mile: " + intakeFilterReplacementMilage.description + "\r\n"
        + " cabin filter replace mile: " + cabinFilterReplacementMilage.description + "\r\n"
        + " coolant change mile: " + coolantChangeInMiles.description + "\r\n"
        + " breake oil change mile: " + breakingOilChangeInMiles.description
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
