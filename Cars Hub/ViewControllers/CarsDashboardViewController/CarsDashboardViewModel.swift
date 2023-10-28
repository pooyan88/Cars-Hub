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
    private var setupNavigationBarTitle: (_ text: String)-> Void
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
            setupNavigationItemTitle()
            isScrollViewHidden(false)
            isInitialViewHidden(true)
            reloadTableView()
        }
    }
    var currentMiles: Int {
        return Int(currentMilageText) ?? 0
    }
    var userCarDetails: CarDetails? {
        set {
            setupNavigationItemTitle()
            guard let newValue = newValue else { return }
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
         setupNavigationBarTitle: @escaping (_ text: String)-> Void,
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
        self.setupNavigationBarTitle = setupNavigationBarTitle
        self.showBanner = showBanner
        getCars()
        setupNavigationItemTitle()
    }
}


//MARK: - Logic
extension CarsDashboardViewModel {
    
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
            return userCarDetails?.carInfo
        }
    }
}

//MARK: - Actions
extension CarsDashboardViewModel {
    
    func updateSummaryLabel() {
        if isTimeBeltFieldValid() {
            updateTimingBeltReplacement(getTimingBeltReplacementDescription())
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
            userCarDetails = CarDetails(currentMilage: currentMilageText, lastEngineOilChangeMilage: engineOilMilageText, lastTransmissionMilage: transmissionOilMilageText, lastTimingBeltReplacementMilage: timeBeltText, lastServiceMilage: lastServiceMilageText, engineOilHelperDescription: getEngineOilDescription(), transmissionOilHelperDescription: getTransmissionOilDescription(), timingBeltReplacementHelperDescription: getTimingBeltReplacementDescription(), nextServiceHelperDescription: getNextServiceDescription(), carInfo: car)
            isScrollViewHidden(false)
        } else { userCarDetails = CarDetails(currentMilage: currentMilageText, lastEngineOilChangeMilage: engineOilMilageText, lastTransmissionMilage: transmissionOilMilageText, lastTimingBeltReplacementMilage: timeBeltText, lastServiceMilage: lastServiceMilageText, engineOilHelperDescription: getEngineOilDescription(), transmissionOilHelperDescription: getTransmissionOilDescription(), timingBeltReplacementHelperDescription: getTimingBeltReplacementDescription(), nextServiceHelperDescription: getNextServiceDescription(), carInfo: userCarDetails?.carInfo)
        }
    }
    
    private func getEngineOilDescription()-> String {
        if let car = selectedCars.first {
            let text = "You have to change your oil at " + CalculateHelper.shared.calculateOilChangeMile(currentMiles: currentMiles, lastOilChangeInMiles: Int(engineOilMilageText) ?? 0, suggestedMiles: car).description + "miles"
            return text
        } else {
            let text = "You have to change your oil at " + CalculateHelper.shared.calculateOilChangeMile(currentMiles: currentMiles, lastOilChangeInMiles: Int(engineOilMilageText) ?? 0, suggestedMiles: (userCarDetails?.carInfo)!).description + "miles"
            return text
        }
    }
    
    private func getTransmissionOilDescription()-> String {
        if let car = selectedCars.first {
            let text = "You have to change your Transmission oil at " + CalculateHelper.shared.calculateTransmissionOilChangeInMiles(currentMiles: currentMiles, lastReplacementInMiles: Int(transmissionOilMilageText) ?? 0, suggestedMiles: car).description + "miles"
            return text
        } else {
            let text = "You have to change your oil at " + CalculateHelper.shared.calculateTransmissionOilChangeInMiles(currentMiles: currentMiles, lastReplacementInMiles: Int(transmissionOilMilageText) ?? 0, suggestedMiles: (userCarDetails?.carInfo)!).description + "miles"
            return text
        }
    }
    
    private func getTimingBeltReplacementDescription()-> String {
        if let car = selectedCars.first {
            if currentMiles == 0 {
                return 0.description
            } else {
                let int = CalculateHelper.shared.calculateTimingBeltReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: Int(timeBeltText) ?? 0, suggestedMiles: car)
                if int == 0 {
                    return "Your timing belt is long life"
                } else {
                    return "You have to replace your timing belt at " + int.description + "miles"
                }
            }
        } else {
            if currentMiles == 0 {
                return 0.description
            } else {
                let int = CalculateHelper.shared.calculateTimingBeltReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: Int(timeBeltText) ?? 0, suggestedMiles: (userCarDetails?.carInfo)!)
                if int == 0 {
                    return "Your timing belt is long life"
                } else {
                    return "You have to replace your timing belt at " + int.description + "miles"
                }
            }
        }
    }
    
    private func getNextServiceDescription()-> String {
            let text = "Engine oil replace mile: " + getOilFilterReplacementMilage().description + "\r\n"
            + " intake filter replace mile: " + getIntakeFilterReplacementMilage().description + "\r\n"
            + " cabin filter replace mile: " + getCabinFilterReplacementMilage().description + "\r\n"
            + " coolant change mile: " + getCoolantChangeMilage().description + "\r\n"
            + " breake oil change mile: " + getBreakingOilChangeDescription().description
            return text
    }
    
    private func getOilFilterReplacementMilage()-> Int {
        if let car = selectedCars.first {
            let oilFilterReplacementMilage = CalculateHelper.shared.calculateOilFilterReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: Int(lastServiceMilageText) ?? 0, suggestedMiles: car)
            return oilFilterReplacementMilage
        } else {
            let oilFilterReplacementMilage = CalculateHelper.shared.calculateOilFilterReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: Int(lastServiceMilageText) ?? 0, suggestedMiles: (userCarDetails?.carInfo!)!)
            return oilFilterReplacementMilage
        }
    }
    
    private func getIntakeFilterReplacementMilage()-> Int {
        if let car = selectedCars.first {
            let intakeFilterReplacementMilage = CalculateHelper.shared.calculateIntakeFilterReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: Int(lastServiceMilageText) ?? 0, suggestedMiles: car)
            return intakeFilterReplacementMilage
        } else {
            let intakeFilterReplacementMilage = CalculateHelper.shared.calculateIntakeFilterReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: Int(lastServiceMilageText) ?? 0, suggestedMiles: (userCarDetails?.carInfo!)!)
            return intakeFilterReplacementMilage
        }
    }
    
    private func getCabinFilterReplacementMilage()-> Int {
        if let car = selectedCars.first {
            let cabinFilterReplacementMilage = CalculateHelper.shared.calculateCabinFilterReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: Int(lastServiceMilageText) ?? 0, suggestedMiles: car)
            return cabinFilterReplacementMilage
        } else {
            let cabinFilterReplacementMilage = CalculateHelper.shared.calculateCabinFilterReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: Int(lastServiceMilageText) ?? 0, suggestedMiles: (userCarDetails?.carInfo!)!)
            return cabinFilterReplacementMilage
        }
    }
    
    private func getCoolantChangeMilage()-> Int {
        if let car = selectedCars.first {
            let coolantChangeInMiles = CalculateHelper.shared.calculateCoolantChangeInMiles(currentMiles: currentMiles, lastReplacementInMiles: Int(lastServiceMilageText) ?? 0, suggestedMiles: car)
            return coolantChangeInMiles
        } else {
            let coolantChangeInMiles = CalculateHelper.shared.calculateCoolantChangeInMiles(currentMiles: currentMiles, lastReplacementInMiles: Int(lastServiceMilageText) ?? 0, suggestedMiles: (userCarDetails?.carInfo!)!)
            return coolantChangeInMiles
        }
    }
    
    private func getBreakingOilChangeDescription()-> String {
        if let car = selectedCars.first {
            let breakingOilChangeInMiles = CalculateHelper.shared.calculateBreakingOilChangeInMiles(currentMiles: currentMiles, lastReplacementInMiles: Int(lastServiceMilageText) ?? 0, suggestedMiles: car)
            return breakingOilChangeInMiles.description
        } else {
            let breakingOilChangeInMiles = CalculateHelper.shared.calculateBreakingOilChangeInMiles(currentMiles: currentMiles, lastReplacementInMiles: Int(lastServiceMilageText) ?? 0, suggestedMiles: (userCarDetails?.carInfo!)!)
            return breakingOilChangeInMiles.description
        }
    }
}


//MARK: - Retrieve User Data
extension CarsDashboardViewModel {
    
    
    func getCurrentMilageText()-> String {
        if let milage = userCarDetails?.currentMilage {
            return milage
        }
        return ""
    }
    
    func getLastEngineOilServiceMilageText()-> String {
        if let lastOilServiceMilage = userCarDetails?.lastEngineOilChangeMilage {
            return lastOilServiceMilage
        }
        return ""
    }
    
    func getLastTransmissionOilServiceMilageText()-> String {
        if let lastTransmissionOilServiceMilage = userCarDetails?.lastTransmissionMilage {
            return lastTransmissionOilServiceMilage
        }
        return ""
    }
    
    func getLastTimingBeltReplacementMilageText()-> String {
        if let lastTimingBeltReplacementMilage = userCarDetails?.lastTimingBeltReplacementMilage {
            return lastTimingBeltReplacementMilage
        }
        return ""
    }
    
    func getLastServiceMilageText()-> String {
        if let lastServiceMilage = userCarDetails?.lastServiceMilage {
            return lastServiceMilage
        }
        return ""
    }
    
    func getChangeOilHelperText()-> String {
        if let changeOilHelperText = userCarDetails?.engineOilHelperDescription {
            return changeOilHelperText
        }
        return "..."
    }
    
    func getChangeTransmissionOilHelperText()-> String {
        if let transmissionOilHelperText = userCarDetails?.transmissionOilHelperDescription {
            return transmissionOilHelperText
        }
        return "..."
    }
    
    func getTimingBeltHelperText()-> String {
        if let timingBeltReplacementHelperText = userCarDetails?.timingBeltReplacementHelperDescription{
            return timingBeltReplacementHelperText
        }
        return "..."
    }
    
    func getNextServiceHelperText()-> String {
        if let nextServiceHelperText = userCarDetails?.nextServiceHelperDescription {
            return nextServiceHelperText
        }
        return "..."
    }
    
    func setupNavigationItemTitle() {
        if let selectedCar = selectedCars.first {
            setupNavigationBarTitle(selectedCar.companyName! + " " + selectedCar.carName!)
        } else if let savedCar = userCarDetails, let companyName = savedCar.carInfo?.companyName, let carName = savedCar.carInfo?.carName {
            setupNavigationBarTitle(companyName + " " + carName)
        } else {
            setupNavigationBarTitle("")
        }
    }
}

//MARK: - API Calls
extension CarsDashboardViewModel {
        
    private func getCars() {
        if let car = userCarDetails?.carInfo {
            carsData = [car]
            showLoading(false)
        } else {
            getAllMakers { [weak self] cars in
                self?.carsData = cars
                self?.isSearchButtonEnable(!cars.isEmpty)
            }
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
