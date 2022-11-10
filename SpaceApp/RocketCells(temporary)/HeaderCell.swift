//
//  HeaderCell.swift
//  SpaceApp
//
//  Created by Григорий Душин on 07.11.2022.
//

import UIKit

final class HeaderCell: UICollectionReusableView {

    @IBOutlet var headerLabel: UILabel!

    func setup(title: String) {
        headerLabel.text = title
    }
}
