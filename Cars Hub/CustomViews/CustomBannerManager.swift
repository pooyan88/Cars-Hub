//
//  CustomBannerManager.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/30/1402 AP.
//

import UIKit

class CustomBannerManager {
    
    static let shared = CustomBannerManager()
    
    private init() { }
    
    func showBanner(message: String, inView view: UIWindow) {
        if !view.subviews.filter({$0.tag == 123456789}).isEmpty { return }
        let banner = CustomBannerView(message: message)
        banner.tag = 123456789
        banner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(banner)
        let height: CGFloat = 50.0
        NSLayoutConstraint.activate([
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            banner.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0),
            banner.heightAnchor.constraint(equalToConstant: height)
        ])
        banner.layer.position.y = -height
        view.layoutIfNeeded()
        view.bringSubviewToFront(banner)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
            banner.layer.position.y = height
            view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                banner.layer.position.y = -height
                view.layoutIfNeeded()
            } completion: { _ in
                banner.removeFromSuperview()
                view.layoutIfNeeded()
            }
        }
    }
}
