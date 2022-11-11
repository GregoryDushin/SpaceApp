//
//  RocketImageCell.swift
//  CompositionalLayoutChallenge
//
//  Created by Григорий Душин on 25.10.2022.
//
import AlamofireImage
import UIKit

final class RocketImageCell: UICollectionViewCell {
    @IBOutlet private var rocketImage: UIImageView!
    @IBOutlet private var rocketNameLabel: UILabel!
    @IBOutlet private var rocketView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        rocketView.layer.masksToBounds = true
        rocketView.layer.cornerRadius = 20
    }

    func setup(url: URL?, rocketName: String) {
        if let imageUrl = url {
            rocketImage.af.setImage(withURL: imageUrl)
        } else {
            rocketImage.image = UIImage(named: "rocket")
        }

        rocketNameLabel.text = rocketName
    }

}
