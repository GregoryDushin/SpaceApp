//
//  RocketLaunchButtonCell.swift
//  CompositionalLayoutChallenge
//
//  Created by Григорий Душин on 25.10.2022.
//

import UIKit

final class RocketLaunchButtonCell: UICollectionViewCell {

    @IBOutlet private var launchButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        launchButton.layer.masksToBounds = true
        launchButton.layer.cornerRadius = 20
    }
}
