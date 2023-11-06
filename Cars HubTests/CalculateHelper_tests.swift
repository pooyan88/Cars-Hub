//
//  CalculateHelper_tests.swift
//  Cars HubTests
//
//  Created by Pooyan J on 8/15/1402 AP.
//

import XCTest
@testable import Cars_Hub

final class CalculateHelper_tests: XCTestCase {
    
    let carData = CarData(id: "1", carName: "TOYOTA", companyName: "Crolla", oilChange: "2000", timingBeltReplacement: "long life", tirePressure: "28", sparkReplacement: "2000", fuelFilterReplacement: "2000", oilFilterReplacement: "2000", intakeFilterReplacement: "2000", cabinFilterReplacement: "2000", transmissionOil: "2000", breakingOil: "2000", coolant: "2000", horspower: "200", torque: "200")
    let currentMiles = 20000
    let lastServiceMilage = 18000
    
    func test_milesToKilometers() {
        XCTAssertEqual(CalculateHelper.shared.milesToKilometers(miles: 10), 16)
        XCTAssertNotEqual(CalculateHelper.shared.milesToKilometers(miles: 10), 17)
    }
    
    func test_calculateOilChangeMilage() {
        XCTAssertEqual(CalculateHelper.shared.calculateOilChangeMile(currentMiles: currentMiles, lastOilChangeInMiles: lastServiceMilage, suggestedMiles: carData), 20000)
        XCTAssertNotEqual(CalculateHelper.shared.calculateOilChangeMile(currentMiles: currentMiles, lastOilChangeInMiles: lastServiceMilage, suggestedMiles: carData), 10000)

    }
    
    func test_calculateTimingBeltReplacementMilage() {
        XCTAssertEqual(CalculateHelper.shared.calculateTimingBeltReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: 0, suggestedMiles: carData), 0)
        XCTAssertNotEqual(CalculateHelper.shared.calculateTimingBeltReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: 0, suggestedMiles: carData), 1)
    }
    
    func test_calculateSparkReplacementMilage() {
        XCTAssertEqual(CalculateHelper.shared.calculateSparkReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastServiceMilage, suggestedMiles: carData), 20000)
        XCTAssertNotEqual(CalculateHelper.shared.calculateSparkReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastServiceMilage, suggestedMiles: carData), 21000)
    }
    
    func test_calculateTransmissionOilChangeInMiles() {
        XCTAssertEqual(CalculateHelper.shared.calculateTransmissionOilChangeInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastServiceMilage, suggestedMiles: carData), 20000)
        XCTAssertNotEqual(CalculateHelper.shared.calculateTransmissionOilChangeInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastServiceMilage, suggestedMiles: carData), 21000)
    }
    
    func test_calculateOilFilterReplacementInMiles() {
        XCTAssertEqual(CalculateHelper.shared.calculateOilFilterReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastServiceMilage, suggestedMiles: carData), 20000)
        XCTAssertNotEqual(CalculateHelper.shared.calculateOilFilterReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastServiceMilage, suggestedMiles: carData), 21000)
    }
    
    func test_calculateIntakeFilterReplacementInMiles() {
        XCTAssertEqual(CalculateHelper.shared.calculateIntakeFilterReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastServiceMilage, suggestedMiles: carData), 20000)
        XCTAssertNotEqual(CalculateHelper.shared.calculateIntakeFilterReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastServiceMilage, suggestedMiles: carData), 21000)
    }
    
    func test_calculateCabinFilterReplacementInMiles() {
        XCTAssertEqual(CalculateHelper.shared.calculateCabinFilterReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastServiceMilage, suggestedMiles: carData), 20000)
        XCTAssertNotEqual(CalculateHelper.shared.calculateCabinFilterReplacementInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastServiceMilage, suggestedMiles: carData), 21000)
    }
    
    func test_calculateBreakingOilChangeInMiles() {
        XCTAssertEqual(CalculateHelper.shared.calculateBreakingOilChangeInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastServiceMilage, suggestedMiles: carData), 20000)
        XCTAssertNotEqual(CalculateHelper.shared.calculateBreakingOilChangeInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastServiceMilage, suggestedMiles: carData), 21000)
    }
    
    func test_calculateCoolantChangeInMiles() {
        XCTAssertEqual(CalculateHelper.shared.calculateCoolantChangeInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastServiceMilage, suggestedMiles: carData), 20000)
        XCTAssertNotEqual(CalculateHelper.shared.calculateCoolantChangeInMiles(currentMiles: currentMiles, lastReplacementInMiles: lastServiceMilage, suggestedMiles: carData), 21000)
    }
}
