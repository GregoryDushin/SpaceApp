//
//  RocketHeaderCell.swift
//  CompositionalLayoutChallenge
//
//  Created by Григорий Душин on 25.10.2022.
//

import UIKit

final class RocketHeaderCell: UICollectionReusableView {
    @IBOutlet weak var rocketHeaderLable: UILabel!
    
    func setup(title: String) {
        rocketHeaderLable.text = title
    }
}
