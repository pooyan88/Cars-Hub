//
//  CarsDashboardViewModel.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/9/1402 AP.
//

import Foundation

class CarsDashboardViewModel {
    
    private var setupSegmentControlHiddenStyle: (_ isHidden: Bool)-> Void
    private var setupScrollViewHiddenStyle: (_ isHidden: Bool)-> Void
    private var reloadTableView: ()-> Void
    private var updateTimingBeltReplacementDescription: (_ text: String)-> Void
    private var updateEngineOilChangeDescription: (_ text: String)-> Void
    private var updateTransmissionOilChangeDescription: (_ text: String)-> Void
    private var updateNextServiceDescription: (_ text: String)-> Void
    private var setupNavigationBarTitle: (_ text: String)-> Void
    private var showBanner: (_ text: String)-> Void
    
    var car: CarData 
    var timeBeltText = ""
    var engineOilMilageText = ""
    var transmissionOilMilageText = ""
    var lastServiceMilageText = ""
    var currentMilageText = "" {
        didSet {
            if !isMillageValid() {
                showBanner("current milage has to be greater than others")
            }
        }
    }
    
    var currentMiles: Int {
        return Int(currentMilageText) ?? 0
    }
    
    init(car: CarData,
         setupSegmentControlHiddenStyle: @escaping (_ isHidden: Bool)-> Void,
         setupScrollViewHiddenStyle: @escaping (_ isHidden: Bool)-> Void,
         reloadTableView: @escaping () -> Void,
         updateTimingBeltReplacementDescription: @escaping (_ text: String)-> Void,
         updateEngineOilChangeDescription: @escaping (_ text: String)-> Void,
         updateTransmissionOilChangeDescription: @escaping (_ text: String)-> Void,
         updateNextServiceDescription: @escaping (_ text: String)-> Void,
         setupNavigationBarTitle: @escaping (_ text: String)-> Void,
         showBanner: @escaping (_ text: String)-> Void) {
        self.car = car
        self.setupSegmentControlHiddenStyle = setupSegmentControlHiddenStyle
        self.setupScrollViewHiddenStyle = setupScrollViewHiddenStyle
        self.reloadTableView = reloadTableView
        self.updateTimingBeltReplacementDescription = updateTimingBeltReplacementDescription
        self.updateEngineOilChangeDescription = updateEngineOilChangeDescription
        self.updateTransmissionOilChangeDescription = updateTransmissionOilChangeDescription
        self.updateNextServiceDescription = updateNextServiceDescription
        self.setupNavigationBarTitle = setupNavigationBarTitle
        self.showBanner = showBanner
    }
}


//MARK: - Logic
extension CarsDashboardViewModel {
    
    private func setupScrollViewHidden() {
        if car.userCarDetails == nil {
            setupScrollViewHiddenStyle(true)
        } else {
            setupScrollViewHiddenStyle(false)
        }
    }
    
    func setupSegmentControlHidden() {
        if car.userCarDetails == nil {
            if car.items.isEmpty {
                setupSegmentControlHiddenStyle(true)
            } else {
                setupSegmentControlHiddenStyle(false)
            }
        }
    }
    
    private func fillEngineOilField() {
        if let lastEngineOilChangeMilage = car.userCarDetails?.lastEngineOilChangeMilage {
            engineOilMilageText = lastEngineOilChangeMilage
        }
    }
}

//MARK: - Actions
extension CarsDashboardViewModel {
    
    func updateSummaryLabel() {
        updateTimingBeltReplacementHelper()
        updateTransmissionOilChangeHelper()
        updateLastServiceHelper()
        updateEngineOilHelper()
    }
    
    private func updateTimingBeltReplacementHelper() {
        if timeBeltText.isEmpty {
            updateTimingBeltReplacementDescription("...")
        } else if isTimeBeltFieldValid() {
            updateTimingBeltReplacementDescription(getTimingBeltReplacementDescription())
        } else {
            updateTimingBeltReplacementDescription("invalid input!")
        }
    }
    
    private func updateTransmissionOilChangeHelper() {
        if transmissionOilMilageText.isEmpty {
            updateTransmissionOilChangeDescription("...")
        } else if isTransmissionOilFieldValid() {
            updateTransmissionOilChangeDescription(getTransmissionOilDescription())
        } else {
            updateTransmissionOilChangeDescription("invalid input!")
        }
    }
    
    private func updateLastServiceHelper() {
        if lastServiceMilageText.isEmpty {
            updateNextServiceDescription("...")
        } else if isLastServiceFieldValid() {
            updateNextServiceDescription(getNextServiceDescription())
        } else {
            updateNextServiceDescription("invalid input!")
        }
    }
    
    private func updateEngineOilHelper() {
        if engineOilMilageText.isEmpty {
            updateEngineOilChangeDescription("...")
        } else if isEngineOilFieldValid() {
            updateEngineOilChangeDescription(getEngineOilDescription())
        } else {
            updateEngineOilChangeDescription("invalid input!")
        }
    }
    
    func setData() {
        if isAllFieldsValid() {
            let userCarDetails = CarDetails(currentMilage: currentMilageText, lastEngineOilChangeMilage: engineOilMilageText, lastTransmissionMilage: transmissionOilMilageText, lastTimingBeltReplacementMilage: timeBeltText, lastServiceMilage: lastServiceMilageText, engineOilHelperDescription: getEngineOilDescription(), transmissionOilHelperDescription: getTransmissionOilDescription(), timingBeltReplacementHelperDescription: getTimingBeltReplacementDescription(), nextServiceHelperDescription: getNextServiceDescription())
            let carInfo = CarData(id: car.id, carName: car.carName, companyName: car.companyName, oilChange: car.oilChange, timingBeltReplacement: car.timingBeltReplacement, tirePressure: car.tirePressure, sparkReplacement: car.sparkReplacement, fuelFilterReplacement: car.fuelFilterReplacement, oilFilterReplacement: car.oilFilterReplacement, intakeFilterReplacement: car.intakeFilterReplacement, cabinFilterReplacement: car.cabinFilterReplacement, transmissionOil: car.transmissionOil, breakingOil: car.breakingOil, coolant: car.coolant, horspower: car.horspower, torque: car.torque, userCarDetails: userCarDetails, isSaved: true)
            saveData(car: carInfo)
        }
    }
    
    private func saveData(car: CarData) {
        DataManager.shared.saveCar(car: car)
    }
    
    private func getEngineOilDescription()-> String {
        if !car.items.isEmpty {
            let text = "You have to change your oil at " + CalculateHelper.shared.calculateOilChangeMile(currentMiles: currentMiles, lastOilChangeInMiles: Int(engineOilMilageText) ?? 0, suggestedMiles: car).description + "miles"
            return text
        }
        return ""
    }
    
    private func getTransmissionOilDescription()-> String {
        if !car.items.isEmpty {
            let text = "You have to change your Transmission oil at " + CalculateHelper.shared.calculateTransmissionOilChangeInMiles(currentMiles: currentMiles, lastReplacementInMiles: Int(transmissionOilMilageText) ?? 0, suggestedMiles: car).description + "miles"
            return text
        } 
        return ""
    }
    
    private func getTimingBeltReplacementDescription()-> String {
        if !car.items.isEmpty {
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
        }
        return ""
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
        if !car.items.isEmpty {
            let oilFilterReplacementMilage = CalculateHelper.shared.calculateOilFilterReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: Int(lastServiceMilageText) ?? 0, suggestedMiles: car)
            return oilFilterReplacementMilage
        }
        return 0
    }
    
    private func getIntakeFilterReplacementMilage()-> Int {
        if !car.items.isEmpty {
            let intakeFilterReplacementMilage = CalculateHelper.shared.calculateIntakeFilterReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: Int(lastServiceMilageText) ?? 0, suggestedMiles: car)
            return intakeFilterReplacementMilage
        }
        return 0
    }
    
    private func getCabinFilterReplacementMilage()-> Int {
        if !car.items.isEmpty{
            let cabinFilterReplacementMilage = CalculateHelper.shared.calculateCabinFilterReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: Int(lastServiceMilageText) ?? 0, suggestedMiles: car)
            return cabinFilterReplacementMilage
        }
        return 0
    }
    
    private func getCoolantChangeMilage()-> Int {
        if !car.items.isEmpty{
            let coolantChangeInMiles = CalculateHelper.shared.calculateCoolantChangeInMiles(currentMiles: currentMiles, lastReplacementInMiles: Int(lastServiceMilageText) ?? 0, suggestedMiles: car)
            return coolantChangeInMiles
        }
        return 0
    }
    
    private func getBreakingOilChangeDescription()-> String {
        if !car.items.isEmpty {
            let breakingOilChangeInMiles = CalculateHelper.shared.calculateBreakingOilChangeInMiles(currentMiles: currentMiles, lastReplacementInMiles: Int(lastServiceMilageText) ?? 0, suggestedMiles: car)
            return breakingOilChangeInMiles.description
        }
        return ""
    }
}

//MARK: - Validations
extension CarsDashboardViewModel {
    
    private func isMillageValid()-> Bool {
        if let last = Int(engineOilMilageText) {
            return currentMiles >= last
        }
        if let last = Int(transmissionOilMilageText) {
            return currentMiles >= last
        }
        if let last = Int(timeBeltText) {
            return currentMiles >= last
        }
        if let last = Int(lastServiceMilageText) {
            return currentMiles >= last
        }
        return false
    }
    
    private func isAllFieldsValid() -> Bool {
        return isTimeBeltFieldValid() && isEngineOilFieldValid() && isTransmissionOilFieldValid() && isLastServiceFieldValid() && isMillageValid()
    }
    
    private func isTimeBeltFieldValid()-> Bool {
        guard let intTimeBeltMilage = Int(timeBeltText) else { return false}
        return timeBeltText.count >= 4 && intTimeBeltMilage < currentMiles
    }
    
    private func isEngineOilFieldValid()-> Bool {
        guard let intEngineOilMilage = Int(engineOilMilageText) else { return false }
        return engineOilMilageText.count >= 4 && intEngineOilMilage < currentMiles
    }
    
    private func isTransmissionOilFieldValid()-> Bool {
        guard let intTransmissionOilMilage = Int(transmissionOilMilageText) else { return false }
        return transmissionOilMilageText.count >= 3 && intTransmissionOilMilage < currentMiles
    }
    
    private func isLastServiceFieldValid()-> Bool {
        guard let intLastServiceMilage = Int(lastServiceMilageText) else { return false}
        return lastServiceMilageText.count >= 3 && intLastServiceMilage < currentMiles
    }
}

//MARK: - Retrieve User Data
extension CarsDashboardViewModel {
    
    func setupNavigationItemTitle() {
        setupNavigationBarTitle(car.fullName)
    }
}
