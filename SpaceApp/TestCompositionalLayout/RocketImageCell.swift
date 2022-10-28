//
//  RocketImageCell.swift
//  CompositionalLayoutChallenge
//
//  Created by Григорий Душин on 25.10.2022.
//

import UIKit

final class RocketImageCell: UICollectionViewCell {
    @IBOutlet var rocketImage: UIImageView!

    func setup(title: String) {
        rocketImage.image = UIImage(named: "rocket")
    }
}
