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
    
    func getAllMakes(completion: @escaping (Result<CarMakesResponse, MyError>)->()) {
        let url = "https://vpic.nhtsa.dot.gov/api/vehicles/GetAllMakes?format=json"
        baseRequest(with: url, type: CarMakesResponse.self, method: .GET, completion: completion)
    }
}

// MARK: - Base Requests
extension NetworkRequests {
    
    private func baseRequest<T:Decodable>(with url: String, type: T.Type, method: RequestType, completion: @escaping (Result<T, MyError>)->()) {
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
            do {
                let result = try JSONDecoder().decode(type, from: data)
                completion(.success(result))
                dump(result)
            } catch {
                completion(.failure(.decodeError))
                print("decode error")
                dump(response)
            }
        }
        task.resume()
    }
}
