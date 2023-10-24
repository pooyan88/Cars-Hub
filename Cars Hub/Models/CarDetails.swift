//
//  CarDetails.swift
//  Cars Hub
//
//  Created by Pooyan J on 8/1/1402 AP.
//

import Foundation

struct CarDetails: Codable {
    var currentMilage: String?
    var lastEngineOilChangeMilage: String?
    var lastTransmissionMilage: String?
    var lastTimingBeltReplacementMilage: String?
    var lastServiceMilage: String?
    var carInfo: CarData?
}
