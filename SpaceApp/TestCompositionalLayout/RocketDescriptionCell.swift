//
//  RocketDescriptionCell.swift
//  CompositionalLayoutChallenge
//
//  Created by Григорий Душин on 25.10.2022.
//

import UIKit

final class RocketDescriptionCell: UICollectionViewCell {
    @IBOutlet weak var mainParametrLable: UILabel!
    @IBOutlet weak var valueParametrLable: UILabel!
    
    func setup(title1: String, title2: String) {
        mainParametrLable.text = title1
        valueParametrLable.text = title2
    }
}
