//
//  CollectionViewCell.swift
//  SpaceX
//
//  Created by Григорий Душин on 09.10.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var rocketNameLable: UILabel!
    @IBOutlet weak var dateOfLaunchLable: UILabel!
    @IBOutlet weak var isSucsessImage: UIImageView!
     func configure(rocket: LaunchModelElement) {
        rocketNameLable.text = rocket.name
        isSucsessImage.image = UIImage(named: rocket.success! ? "true" : "false")
        dateOfLaunchLable.text = dateFormatter(utcDate: rocket.dateUtc)
     }
    private  func dateFormatter (utcDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let result = dateFormatter.date(from: utcDate)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: result!)
    }
}
