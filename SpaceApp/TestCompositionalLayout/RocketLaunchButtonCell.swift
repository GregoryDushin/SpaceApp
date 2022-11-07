//
//  RocketLaunchButtonCell.swift
//  CompositionalLayoutChallenge
//
//  Created by Григорий Душин on 25.10.2022.
//

import UIKit

final class RocketLaunchButton: UICollectionViewCell {
    @IBOutlet var launchButton: UIButton!

    func setup() {
        launchButton.layer.masksToBounds = true
        launchButton.layer.cornerRadius = 20
    }
}
