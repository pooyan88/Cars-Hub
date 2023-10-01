//
//  CAGradientLayerExtension.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/8/1402 AP.
//

import UIKit

extension CALayer {
    
    func createGradientLayer(view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        let black = UIColor.black.cgColor
        let darkBlue = UIColor(red: 0.0, green: 0.0, blue: 0.2, alpha: 1.0).cgColor
        let darkGreen = UIColor.darkGreen.cgColor
        gradientLayer.colors = [black, darkBlue, darkGreen, black]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        self.insertSublayer(gradientLayer, at: 0)
    }
}
