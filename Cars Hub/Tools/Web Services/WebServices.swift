//
//  WebServices.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/5/1402 AP.
//

import Foundation


class NetworkRequests {
    
    enum MyError: Error {
        case serverError
        case urlError
        case decodeError
    }
    
    enum RequestType: String { case POST, GET, PUT, PATCH }
    
    static let shared = NetworkRequests()
    
    private init() {}
}

//MARK: - API Calls
extension NetworkRequests {
    
    func getAllMakes(completion: @escaping (Result<[CarData], MyError>)->()) {
        let url = "https://docs.google.com/spreadsheets/d/e/2PACX-1vTWYOsHsql0kyqg3sj5XbHdvkP_hFnBYM9PG6tdAzhPjNfcxYWporM59yp7fsM2WlzRixhgl06vbl2I/pub?output=csv"
        baseRequest(with: url, type: Data.self, method: .GET, completion: completion)
    }
}

// MARK: - Base Requests
extension NetworkRequests {
    
    private func baseRequest<T:Decodable>(with url: String, type: T.Type, method: RequestType, completion: @escaping (Result<[CarData], MyError>)->()) {
        guard let url = URL(string: url) else {
            completion(.failure(.urlError))
            print("URL Error")
            return
        }
        let request = URLRequest(url: url)
        print("URL :", url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.serverError))
                print("server error")
                return
            }
            completion(.success(self.convertCSVIntoArray(data: data)))
            dump(self.convertCSVIntoArray(data: data))
        }
        task.resume()
    }
}

//MARK: - CSV To Array
extension NetworkRequests {
    
    func convertCSVIntoArray(data: Data)-> [CarData] {
        var tempCars: [CarData] = []
        let dataString = String(data: data, encoding: .utf8) ?? ""
        var rows = dataString.components(separatedBy: "\n")
        rows.removeFirst()
        for row in rows {
            let columns = row.components(separatedBy: ",")
            let id = columns[0].replacingOccurrences(of: "**", with: ",")
            let carName = columns[1].replacingOccurrences(of: "**", with: ",")
            let companyName = columns[2].replacingOccurrences(of: "**", with: ",")
            let oilChange = columns[3].replacingOccurrences(of: "**", with: ",")
            let timingBeltReplacement = columns[4].replacingOccurrences(of: "**", with: ",")
            let tirePressure = columns[5].replacingOccurrences(of: "**", with: ",")
            let sparkReplacement = columns[6].replacingOccurrences(of: "**", with: ",")
            let fuelFilterReplacement = columns[7].replacingOccurrences(of: "**", with: ",")
            let oilFilterReplacement = columns[8].replacingOccurrences(of: "**", with: ",")
            let intakeFilterReplacement = columns[9].replacingOccurrences(of: "**", with: ",")
            let cabinFilterReplacement = columns[10].replacingOccurrences(of: "**", with: ",")
            let transmissionOil = columns[11].replacingOccurrences(of: "**", with: ",")
            let breakingOil = columns[12].replacingOccurrences(of: "**", with: ",")
            let coolant = columns[13].replacingOccurrences(of: "**", with: ",")
            let horsepower = columns[14].replacingOccurrences(of: "**", with: ",")
            let torque = columns[15].replacingOccurrences(of: "**", with: ",")
            
            let data = CarData(id: id, carName: carName, companyName: companyName, oilChange: oilChange, timingBeltReplacement: timingBeltReplacement, tirePressure: tirePressure, sparkReplacement: sparkReplacement, fuelFilterReplacement: fuelFilterReplacement, oilFilterReplacement: oilFilterReplacement, intakeFilterReplacement: intakeFilterReplacement, cabinFilterReplacement: cabinFilterReplacement, transmissionOil: transmissionOil, breakingOil: breakingOil, coolant: coolant, horspower: horsepower, torque: torque)
            tempCars.append(data)
        }
        return tempCars
    }
}
