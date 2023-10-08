//
//  CalculateHelper.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/16/1402 AP.
//

import Foundation


class CalculateHelper {
    
    static let shared = CalculateHelper()
    
    private init() {}
    
    func milesToKilometers( miles: Int) -> Int {
        let unit: Double = 1.60934
        let kilometers = Double(miles) * unit
        return Int(kilometers)
    }
    
    func calculateOilChangeMile(currentMiles: Int, lastOilChangeInMiles: Int, suggestedMiles: CarsData)-> Int {
        if let suggestedMiles = Int.parseToInt(from: suggestedMiles.oilChange ?? "?") {
            return (suggestedMiles - (currentMiles-lastOilChangeInMiles)) + currentMiles
        }
        return 0
    }
    
    func calculateTimingBeltReplacementInMiles(currentMiles: Int, lastReplacementInMiles: Int, suggestedMiles: CarsData)-> Int {
        if suggestedMiles.timingBeltReplacement == "long life" {
            return 0
        } else {
            if let suggestedMiles = Int(suggestedMiles.timingBeltReplacement ?? "?") {
                return (suggestedMiles - (currentMiles-lastReplacementInMiles)) + currentMiles
            }
            return 0
        }
    }
    
    func calculateSparkReplacementInMiles(currentMiles: Int, lastReplacementInMiles: Int, suggestedMiles: CarsData)-> Int {
        if let suggestedMiles = Int(suggestedMiles.sparkReplacement ?? "?") {
            return (suggestedMiles - (currentMiles-lastReplacementInMiles)) + currentMiles
        }
        return 0
    }
    
    func calculateTransmissionOilChangeInMiles(currentMiles: Int, lastReplacementInMiles: Int, suggestedMiles: CarsData)-> Int {
        if let suggestedMiles = Int(suggestedMiles.transmissionOil ?? "?") {
            return (suggestedMiles - (currentMiles-lastReplacementInMiles)) + currentMiles
        }
        return 0
    }
    
    func calculateOilFilterReplacementInMiles(currentMiles: Int, lastReplacementInMiles: Int, suggestedMiles: CarsData)-> Int {
        if let suggestedMiles = Int(suggestedMiles.oilFilterReplacement ?? "?") {
            return (suggestedMiles - (currentMiles-lastReplacementInMiles)) + currentMiles
        }
        return 0
    }
    
    func calculateIntakeFilterReplacementInMiles(currentMiles: Int, lastReplacementInMiles: Int, suggestedMiles: CarsData)-> Int {
        if let suggestedMiles = Int(suggestedMiles.intakeFilterReplacement ?? "?") {
            return (suggestedMiles - (currentMiles-lastReplacementInMiles)) + currentMiles
        }
        return 0
    }
    
    func calculateCabinFilterReplacementInMiles(currentMiles: Int, lastReplacementInMiles: Int, suggestedMiles: CarsData)-> Int {
        if let suggestedMiles = Int(suggestedMiles.cabinFilterReplacement ?? "?") {
            return (suggestedMiles - (currentMiles-lastReplacementInMiles)) + currentMiles
        }
        return 0
    }
    
    func calculateBreakingOilChangeInMiles(currentMiles: Int, lastReplacementInMiles: Int, suggestedMiles: CarsData)-> Int {
        if let suggestedMiles = Int(suggestedMiles.breakingOil ?? "?") {
            return (suggestedMiles - (currentMiles-lastReplacementInMiles)) + currentMiles
        }
        return 0
    }
    
    func calculateCoolantChangeInMiles(currentMiles: Int, lastReplacementInMiles: Int, suggestedMiles: CarsData)-> Int {
        if let suggestedMiles = Int(suggestedMiles.coolant ?? "?") {
            return (suggestedMiles - (currentMiles-lastReplacementInMiles)) + currentMiles
        }
        return 0
    }
}

