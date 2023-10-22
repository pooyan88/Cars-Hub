//
//  CustomBannerView.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/30/1402 AP.
//

import UIKit

class CustomBannerView: UIView {

    init(message: String) {
        super.init(frame: CGRect.zero)
        configureBannerView(message: message)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureBannerView(message: "")
    }
    
    private func configureBannerView(message: String) {
        backgroundColor = .red
        layer.cornerRadius = 8
        
        let label = UILabel()
        label.text = message
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
}

