//
//  RocketNameCell.swift
//  CompositionalLayoutChallenge
//
//  Created by Григорий Душин on 25.10.2022.
//

import UIKit

final class RocketNameCell: UICollectionViewCell {
    @IBOutlet weak var rocketNameLable: UILabel!
    @IBOutlet weak var rocketSettingsButton: UIButton!
    
    func setup(title: String) {
        rocketNameLable.text = title
    }
}
