//
//  CarsDashboardViewModel.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/9/1402 AP.
//

import Foundation

class CarsDashboardViewModel {
        
    private var showLoading: (_ isAnimating: Bool)-> Void
    private var isSearchButtonEnable: (_ isEnable: Bool)-> Void
    private var isTableViewHidden: (_ isHidden: Bool)-> Void
    private var isScrollViewHidden: (_ isHidden: Bool)-> Void
    private var isInitialViewHidden: (_ isHidden: Bool)-> Void
    private var reloadTableView: ()-> Void
    private var updateTimingBeltReplacement: (_ text: String)-> Void
    private var updateEngineOilMilageText: (_ text: String)-> Void
    private var updateTransmissionOilMilageText: (_ text: String)-> Void
    private var updateNextServiceMilageText: (_ text: String)-> Void
    private var showBanner: (_ text: String)-> Void
    var timeBeltText = ""
    var engineOilMilageText = ""
    var transmissionOilMilageText = ""
    var lastServiceMilageText = ""
    var carsData: [CarData] = []
    var currentMilageText = "" {
        didSet {
            if isMillageValid() == true {
                showErrorBanner(error: "Milage has to be greater than last service")
            }
        }
    }
    var selectedCars: [CarData] = [] {
        didSet {
            isScrollViewHidden(false)
            isInitialViewHidden(true)
            reloadTableView()
        }
    }
    var currentMiles: Int {
        return Int(currentMilageText) ?? 0
    }
    var userCarDetails: CarDetails! {
        set {
            DataManager.shared.saveCarDetails(details: newValue)
            setupScollViewHiddenStyle()
        } get {
            DataManager.shared.loadCarDetails()
        }
    }
    
    init(showLoading: @escaping (_: Bool) -> Void,
         isSearchButtonEnable: @escaping (_: Bool) -> Void,
         isTableViewHidden:@escaping (_ isHidden: Bool)-> Void,
         isScrollViewHidden: @escaping (_ isHidden: Bool)-> Void,
         isInitialViewHidden: @escaping (_ isHidden: Bool)-> Void,
         reloadTableView: @escaping () -> Void,
         updateTimingBeltReplacement: @escaping (_ text: String)-> Void,
         updateEngineOilMilageText: @escaping (_ text: String)-> Void,
         updateTransmissionOilMilageText: @escaping (_ text: String)-> Void,
         updateNextServiceMilageText: @escaping (_ text: String)-> Void,
         showBanner: @escaping (_ text: String)-> Void) {
        self.showLoading = showLoading
        self.isSearchButtonEnable = isSearchButtonEnable
        self.isTableViewHidden = isTableViewHidden
        self.isScrollViewHidden = isScrollViewHidden
        self.isInitialViewHidden = isInitialViewHidden
        self.reloadTableView = reloadTableView
        self.updateTimingBeltReplacement = updateTimingBeltReplacement
        self.updateEngineOilMilageText = updateEngineOilMilageText
        self.updateTransmissionOilMilageText = updateTransmissionOilMilageText
        self.updateNextServiceMilageText = updateNextServiceMilageText
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
    
    private func getTransmissionOilDescription()-> String {
        if transmissionOilMilageText.count >= 3 {
            return getTransmissionOilDescription(currentMiles: currentMiles, lastOilChangeInMiles: Int(transmissionOilMilageText) ?? 0)
        }
        return "?"
    }
    
    private func getNextServiceDescription()-> String {
        if lastServiceMilageText.count >= 3 {
            return getNextServiceDescription(currentMiles: currentMiles, lastOIlChangeInMiles: Int(lastServiceMilageText) ?? 0)
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
    
    private func isTransmissionOilFieldValid()-> Bool {
        return transmissionOilMilageText.count >= 3
    }
    
    private func isLastServiceFieldValid()-> Bool {
        return lastServiceMilageText.count >= 3
    }
    
    private func showErrorBanner(error: String) {
        if !isTimeBeltFieldValid() {
            showBanner(error)
        }
    }
    
    private func isMillageValid()-> Bool {
        if currentMilageText.count > timeBeltText.count {
            return false
        }
        if currentMilageText.count > engineOilMilageText.count {
            return false
        }
        if currentMilageText.count > transmissionOilMilageText.count {
            return false
        }
        if currentMilageText.count > lastServiceMilageText.count {
            return false
        }
        return true
    }
    
    private func setupScollViewHiddenStyle() {
        if userCarDetails == nil {
            isScrollViewHidden(true)
        } else {
            isScrollViewHidden(false)
        }
    }
    
    func getItem() -> CarData? {
        if userCarDetails == nil {
            return selectedCars[0]
        } else {
            return userCarDetails.carInfo
        }
    }
}

//MARK: - Actions
extension CarsDashboardViewModel {
    
    func updateSummaryLabel() {
        if isTimeBeltFieldValid() {
            updateTimingBeltReplacement(getTimeBeltDescription())
        }
        if isEngineOilFieldValid() {
            updateEngineOilMilageText(getEngineOilDescription())
        }
        if isTransmissionOilFieldValid() {
            updateTransmissionOilMilageText(getTransmissionOilDescription())
        }
        if isLastServiceFieldValid() {
            updateNextServiceMilageText(getNextServiceDescription())
        } else if !lastServiceMilageText.isEmpty && lastServiceMilageText.count < 3 || isMillageValid() {
            updateNextServiceMilageText("...")
            showErrorBanner(error: "enter at least 3 characters")
        } else if !transmissionOilMilageText.isEmpty && transmissionOilMilageText.count < 3 || isMillageValid() {
            updateTransmissionOilMilageText("...")
            showErrorBanner(error: "enter at least 3 characters")
        } else if !timeBeltText.isEmpty && timeBeltText.count < 3 || isMillageValid() {
            updateTimingBeltReplacement("...")
            showErrorBanner(error: "enter at least 3 characters")
        } else if !engineOilMilageText.isEmpty && engineOilMilageText.count < 3 || isMillageValid() {
            updateEngineOilMilageText("...")
            showErrorBanner(error: "enter at least 3 characters")
        }
        if let car = selectedCars.first {
            userCarDetails = CarDetails(currentMilage: currentMilageText, lastEngineOilChangeMilage: engineOilMilageText, lastTransmissionMilage: transmissionOilMilageText, lastTimingBeltReplacementMilage: timeBeltText, lastServiceMilage: lastServiceMilageText, carInfo: car)
            isScrollViewHidden(false)
        }
    }
    
    func getEngineOilDescription(currentMiles: Int, lastOilChangeInMiles: Int)-> String {
        guard let car = selectedCars.first else { return "..."}
        let text = "You have to change your oil at " + CalculateHelper.shared.calculateOilChangeMile(currentMiles: currentMiles, lastOilChangeInMiles: lastOilChangeInMiles, suggestedMiles: car).description + "miles"
        return text
    }
    
    func getTransmissionOilDescription(currentMiles: Int, lastOilChangeInMiles: Int)-> String {
        guard let car = selectedCars.first else { return "..."}
        let text = "You have to change your Transmission oil at " + CalculateHelper.shared.calculateTransmissionOilChangeInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastOilChangeInMiles, suggestedMiles: car).description + "miles"
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
        guard let car = selectedCars.first else {return "..."}
        let oilFilterReplacementMilage = CalculateHelper.shared.calculateOilFilterReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastOIlChangeInMiles, suggestedMiles: car)
        let intakeFilterReplacementMilage = CalculateHelper.shared.calculateIntakeFilterReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastOIlChangeInMiles, suggestedMiles: car)
        let cabinFilterReplacementMilage = CalculateHelper.shared.calculateCabinFilterReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastOIlChangeInMiles, suggestedMiles: car)
        let coolantChangeInMiles = CalculateHelper.shared.calculateCoolantChangeInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastOIlChangeInMiles, suggestedMiles: car)
        let breakingOilChangeInMiles = CalculateHelper.shared.calculateBreakingOilChangeInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastOIlChangeInMiles, suggestedMiles: car)
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
        
    private func getCars() {
        getAllMakers { [weak self] cars in
            self?.carsData = cars
            self?.isSearchButtonEnable(!cars.isEmpty)
        }
    }
    
    private func getAllMakers(completions: @escaping ([CarData])-> Void) {
        showLoading(true)
        isSearchButtonEnable(false)
        NetworkRequests.shared.getAllMakes { [weak self] response in
            guard let self else { return }
            DispatchQueue.main.async {
                self.showLoading(false)
                switch response {
                case .success(let data):
                    completions(data)
                case .failure(let error):
                    completions([])
                    print("decode error", error.localizedDescription)
                }
            }
        }
    }
}
