//
//  CarMakesResponse.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/5/1402 AP.
//

import Foundation


struct CarData: Codable {
    let id: String?
    let carName: String?
    let companyName: String?
    let oilChange: String?
    let timingBeltReplacement: String?
    let tirePressure: String?
    let sparkReplacement: String?
    let fuelFilterReplacement: String?
    let oilFilterReplacement: String?
    let intakeFilterReplacement: String?
    let cabinFilterReplacement: String?
    let transmissionOil: String?
    let breakingOil: String?
    let coolant: String?
    let horspower: String?
    let torque: String?
    var userCarDetails: CarDetails?
    var isSaved: Bool = false
    var fullName: String {
        return (companyName ?? "") + " " + (carName ?? "")
    }
    
    var items: [(title: String, value: String)] {
        var temp: [(title: String, value: String)] = []
        if let carName = carName {
            temp.append((title: "Car Name", value: carName))
        }
        if let companyName = companyName {
            temp.append((title: "Company Name", value: companyName))
        }
        if let oilChange = oilChange {
            temp.append((title: "Oil Change", value: oilChange))
        }
        if let timingBeltReplacement = timingBeltReplacement {
            temp.append((title: "Timing Belt Replacement", value: timingBeltReplacement))
        }
        if let tirePressure = tirePressure {
            temp.append((title: "Tire Pressure", value: tirePressure))
        }
        if let sparkReplacement = sparkReplacement {
            temp.append((title: "Spark Replacement", value: sparkReplacement))
        }
        if let fuelFilterReplacement = fuelFilterReplacement {
            temp.append((title: "Fuel Filter Replacement", value: fuelFilterReplacement))
        }
        if let oilFilterReplacement = oilFilterReplacement {
            temp.append((title: "Oil Filter Replacement", value: oilFilterReplacement))
        }
        if let intakeFilterReplacement = intakeFilterReplacement {
            temp.append((title: "Intake Filter Replacement", value: intakeFilterReplacement))
        }
        if let cabinFilterReplacement = cabinFilterReplacement {
            temp.append((title: "Cabin Filter Replacement", value: cabinFilterReplacement))
        }
        if let transmissionOil = companyName {
            temp.append((title: "Transmission Oil Change", value: transmissionOil))
        }
        if let breakingOil = companyName {
            temp.append((title: "Breaking Oil Change", value: breakingOil))
        }
        if let coolant = coolant {
            temp.append((title: "Coolant Change", value: coolant))
        }
        if let horspower = horspower {
            temp.append((title: "Power", value: horspower))
        }
        if let torque = torque {
            temp.append((title: "Torque", value: torque))
        }
        return temp
    }
}
