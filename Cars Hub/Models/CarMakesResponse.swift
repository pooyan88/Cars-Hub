//
//  CarMakesResponse.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/5/1402 AP.
//

import Foundation


struct CarMakesResponse: Codable {
    let count: Int?
    let message: String?
    let results: [SearchResult]
    
    
    enum CodingKeys: String, CodingKey {
        case count = "Count"
        case message = "Message"
        case results = "Results"
    }
    
    struct SearchResult: Codable {
        let makeName: String?
        
        enum CodingKeys: String, CodingKey {
            case makeName = "Make_Name"
        }
    }
}
