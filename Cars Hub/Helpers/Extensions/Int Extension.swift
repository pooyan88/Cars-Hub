//
//  Int Extension.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/16/1402 AP.
//

import Foundation

extension Int {
    static func parseToInt(from string: String) -> Int? {
        Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
}
