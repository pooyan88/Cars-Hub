//
//  DataManager.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/5/1402 AP.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    
    func saveCarDetails(details: CarDetails) {
        let encodedData = try? JSONEncoder().encode(details)
        UserDefaults.standard.set(encodedData, forKey: "details")
    }
    
    func loadCarDetails()-> CarDetails? {
        if let data = UserDefaults.standard.data(forKey: "details") {
            if let decodedData = try? JSONDecoder().decode(CarDetails.self, from: data) {
                return decodedData
            }
        }
        return nil
    }
}
