//
//  DataManager.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/5/1402 AP.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    
    func saveCars(cars: [CarsData]) {
        let encodedData = try? JSONEncoder().encode(cars)
        UserDefaults.standard.set(encodedData, forKey: "cars")
    }
    
    func loadCars()-> [CarsData] {
        if let data = UserDefaults.standard.data(forKey: "cars") {
            if let decodedData = try? JSONDecoder().decode([CarsData].self, from: data) {
                return decodedData
            }
        }
        return []
    }
}
