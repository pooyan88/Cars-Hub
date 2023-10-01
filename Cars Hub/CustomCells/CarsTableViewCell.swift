//
//  CarsTableViewCell.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/8/1402 AP.
//

import UIKit

final class CarsTableViewCell: UITableViewCell {
    
    struct Config {
        var carTitle: String
    }
    
    @IBOutlet weak var carsTitleLabel: UILabel!
    
    static let identifier: String = "CarsTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
}

//MARK: - Setup Functions
extension CarsTableViewCell {
    
    func setup(data: CarMakesResponse.SearchResult) {
        let config = Config(carTitle: data.makeName ?? "?")
        setup(config: config)
    }
    
    private func setup(config: Config) {
        carsTitleLabel.text = config.carTitle
    }
    
    private func setupUI() {
        carsTitleLabel.textColor = .white
    }
}
