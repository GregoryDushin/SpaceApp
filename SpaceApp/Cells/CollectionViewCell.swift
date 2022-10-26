//
//  CollectionViewCell.swift
//  SpaceX
//
//  Created by Григорий Душин on 09.10.2022.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var rocketNameLable: UILabel!
    @IBOutlet var dateOfLaunchLable: UILabel!
    @IBOutlet var isSucsessImage: UIImageView!

    func configure(rocket: LaunchModelElement, dates: String) {
        rocketNameLable.text = rocket.name
        if let launchingResult = rocket.success {
        isSucsessImage.image = UIImage(named: launchingResult ? "true" : "false")
        } else {
            return
        }
        dateOfLaunchLable.text = dates
        layer.masksToBounds = true
        layer.cornerRadius = 12
     }
}
