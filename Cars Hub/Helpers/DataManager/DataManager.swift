//
//  DataManager.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/5/1402 AP.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    func saveCars(cars: [CarData]) {
        let encodedData = try? JSONEncoder().encode(cars)
        UserDefaults.standard.set(encodedData, forKey: "cars")
    }
    
    func loadCars()-> [CarData]? {
        if let data = UserDefaults.standard.data(forKey: "cars") {
            if let decodedData = try? JSONDecoder().decode([CarData].self, from: data) {
                return decodedData
            }
        }
        return nil
    }
    
    func saveCar(car: CarData) {
        var cars = loadCars() ?? []
        //        if cars.contains(where: { carItem in return car.fullName == carItem.fullName }) {
        //
        //        }
        if let index = cars.firstIndex(where: { $0.fullName == car.fullName }) {
            cars[index] = car
        } else {
            cars.append(car)
        }
        saveCars(cars: cars)
    }
    func saveCarsList(cars: [CarData]) {
        let encodedData = try? JSONEncoder().encode(cars)
        UserDefaults.standard.setValue(encodedData, forKey: "cars_list")
    }
    
    func loadCarsList()-> [CarData]? {
        if let data = UserDefaults.standard.data(forKey: "cars_list") {
            if let decodedData = try? JSONDecoder().decode([CarData].self, from: data) {
                return decodedData
            }
        }
        return []
    }
}
