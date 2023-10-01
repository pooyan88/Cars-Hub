//
//  DataManager.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/5/1402 AP.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
     func saveCars(data: [CarMakesResponse.SearchResult]) {
        let encodedWeatherConditions = try? JSONEncoder().encode(data)
        UserDefaults.standard.set(encodedWeatherConditions, forKey: "cars")
    }
    
     func loadCars() -> [CarMakesResponse.SearchResult]{
        if let data = UserDefaults.standard.data(forKey: "cars") {
            if let decodedData = try? JSONDecoder().decode([CarMakesResponse.SearchResult].self, from: data) {
                return decodedData
            }
        }
        return []
    }
}
