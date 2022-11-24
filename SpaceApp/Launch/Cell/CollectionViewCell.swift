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
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = 12
    }

    func configure(name: String, date: String, image: UIImage?) {
        rocketNameLabel.text = name
        dateOfLaunchLabel.text = date
        isSucsessImage.image = image
    }
}
