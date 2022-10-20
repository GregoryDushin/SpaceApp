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

     func configure(rocket: LaunchModelElement) {
        rocketNameLable.text = rocket.name
        isSucsessImage.image = UIImage(named: rocket.success! ? "true" : "false")
        dateOfLaunchLable.text = dateFormatter(utcDate: rocket.dateUtc)
        layer.masksToBounds = true
        layer.cornerRadius = 12
     }

    private  func dateFormatter (utcDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"
        return dateFormatter.string(from: utcDate)
    }
}
