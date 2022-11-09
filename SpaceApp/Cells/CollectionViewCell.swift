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
    
    override func awakeFromNib() {
        super .awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = 12
    }
    
    func configure(rocket: LaunchModelElement, dates: String) {
        rocketNameLable.text = rocket.name
        dateOfLaunchLable.text = dates
        if let launchingResult = rocket.success {
            isSucsessImage.image = UIImage(named: (launchingResult ? LaunchImages.success : LaunchImages.unsucsess).rawValue)
        } else {
            return
        }
    }
}
