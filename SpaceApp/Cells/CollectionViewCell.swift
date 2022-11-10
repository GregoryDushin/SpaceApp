//
//  CollectionViewCell.swift
//  SpaceX
//
//  Created by Григорий Душин on 09.10.2022.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    @IBOutlet private var rocketNameLabel: UILabel!
    @IBOutlet private var dateOfLaunchLabel: UILabel!
    @IBOutlet private var isSucsessImage: UIImageView!

    override func awakeFromNib() {
        super .awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = 12
    }
    

    func configure(rocket: LaunchModelElement, dates: String) {
        rocketNameLabel.text = rocket.name
        dateOfLaunchLabel.text = dates
        if let launchingResult = rocket.success {
            isSucsessImage.image = UIImage(named: (launchingResult ? LaunchImages.success : LaunchImages.unsucsess))
        } else {
            return
        }
    }
}
