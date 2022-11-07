//
//  RocketImageCell.swift
//  CompositionalLayoutChallenge
//
//  Created by Григорий Душин on 25.10.2022.
//

import UIKit
import Alamofire
import AlamofireImage

final class RocketImageCell: UICollectionViewCell {
    @IBOutlet var rocketImage: UIImageView!
    @IBOutlet var rocketNameLabel: UILabel!
    @IBOutlet var rocketView: UIView!

    func setup(url: URL?, rocketName: String) {
        if let imageUrl = url {
            rocketImage.af.setImage(withURL: imageUrl)
        } else {
            rocketImage.image = UIImage(named: "rocket")
        }

        rocketNameLabel.text = rocketName
        rocketView.layer.masksToBounds = true
        rocketView.layer.cornerRadius = 20
    }

}
