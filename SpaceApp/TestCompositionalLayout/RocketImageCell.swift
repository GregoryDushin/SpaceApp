//
//  RocketImageCell.swift
//  CompositionalLayoutChallenge
//
//  Created by Григорий Душин on 25.10.2022.
//

import UIKit

final class RocketImageCell: UICollectionViewCell {
    @IBOutlet var rocketImage: UIImageView!
    @IBOutlet var rocketNameLabel: UILabel!
    @IBOutlet var rocketView: UIView!
    
    func setup(url: String, rocketName: String ) {
        rocketImage.image = UIImage(named: "rocket")
        rocketNameLabel.text = rocketName
    }
}
