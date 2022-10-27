//
//  RocketAnotherInfoCell.swift
//  CompositionalLayoutChallenge
//
//  Created by Григорий Душин on 25.10.2022.
//

import UIKit

class RocketAnotherInfoCell: UICollectionViewCell {
    @IBOutlet weak var nameSettingsLable: UILabel!
    @IBOutlet weak var valueSettingsLable: UILabel!
    
    func setup(title1: String, title2: String) {
        nameSettingsLable.text = title1
        valueSettingsLable.text = title2
    }
    
}
