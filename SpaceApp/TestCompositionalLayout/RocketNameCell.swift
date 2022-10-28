//
//  RocketNameCell.swift
//  CompositionalLayoutChallenge
//
//  Created by Григорий Душин on 25.10.2022.
//

import UIKit

final class RocketNameCell: UICollectionViewCell {
    @IBOutlet var rocketNameLable: UILabel!
    @IBOutlet var rocketSettingsButton: UIButton!

    func setup(title: String) {
        rocketNameLable.text = title
    }
}
