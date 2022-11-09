//
//  RocketAnotherInfoCell.swift
//  CompositionalLayoutChallenge
//
//  Created by Григорий Душин on 25.10.2022.
//

import UIKit

final class RocketVerticalInfoCell: UICollectionViewCell {
    @IBOutlet private var nameSettingsLabel: UILabel!
    @IBOutlet private var valueSettingsLabel: UILabel!

    func setup(title: String, value: String) {
        nameSettingsLabel.text = title
        valueSettingsLabel.text = value
    }
}
