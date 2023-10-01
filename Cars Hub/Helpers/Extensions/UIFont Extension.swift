//
//  UIFont Extension.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/8/1402 AP.
//

import UIKit

extension UIFont {
    func bold(withSize size: CGFloat) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(.traitBold)?
            .withSize(size)
        
        return UIFont(descriptor: descriptor!, size: size)
    }
}
