//
//  CarDetailsTableViewCell.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/15/1402 AP.
//

import UIKit

class CarDetailsTableViewCell: UITableViewCell {
    
    struct Config {
        var carFullName: String
        var oilChange: String
        var timingBeltChange: String
        var tirePressurePeriod: String
        var sparkReplace: String
        var fuelFilterReplace: String
        var oilFilterReplace: String
        var intakeFilterReplace: String
        var cabinFilterReplace: String
        var transmissionOilChange: String
        var breakingOilReplace: String
        var coolantChange: String
        var power: String
        var torque: String
    }

    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var oilChangeLabel: UILabel!
    @IBOutlet weak var timingBeltLabel: UILabel!
    @IBOutlet weak var tirePressureLabel: UILabel!
    @IBOutlet weak var sparkReplaceLabel: UILabel!
    @IBOutlet weak var fuelFilterReplaceLabel: UILabel!
    @IBOutlet weak var oilFilterReplaceLabel: UILabel!
    @IBOutlet weak var intakeFilterReplaceLabel: UILabel!
    @IBOutlet weak var cabinFilterReplaceLabel: UILabel!
    @IBOutlet weak var transmissionOilChangeLabel: UILabel!
    @IBOutlet weak var breakingOilChangeLabel: UILabel!
    @IBOutlet weak var coolantChangeLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var torqueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
}

//MARK: - Setup Functions
extension CarDetailsTableViewCell {
    
    private func setupUI() {

    }
    
    private func setup(config: Config) {

    }
    
    func setup(data: CarsData) {
       
    }
}
