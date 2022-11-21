//
//  RocketDescriptionCell.swift
//  CompositionalLayoutChallenge
//
//  Created by Григорий Душин on 25.10.2022.
//

import UIKit

final class RocketHorizontalInfoCell: UICollectionViewCell {
    @IBOutlet private var mainParametrLabel: UILabel!
    @IBOutlet private var valueParametrLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = 60
    }

    func setup(title: String, value: String) {
        mainParametrLabel.text = title
        valueParametrLabel.text = value
    }

}
