//
//  CollectionViewCell.swift
//  SpaceX
//
//  Created by Григорий Душин on 09.10.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var rocketNameLable: UILabel!
    @IBOutlet var dateOfLaunchLable: UILabel!
    @IBOutlet var isSucsessImage: UIImageView!

    func configure(rocket: LaunchModelElement, dates: String) {
        rocketNameLable.text = rocket.name
        isSucsessImage.image = UIImage(named: rocket.success! ? "true" : "false")
        dateOfLaunchLable.text = dates
        layer.masksToBounds = true
        layer.masksToBounds = true
        layer.cornerRadius = 12
     }
}
