//
//  RocketLaunchButtonCell.swift
//  CompositionalLayoutChallenge
//
//  Created by Григорий Душин on 25.10.2022.
//

import UIKit

final class RocketLaunchButton: UICollectionViewCell {
    @IBOutlet private var launchButton: UIButton!

    override func awakeFromNib() {
        super .awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = 20
    }

}
