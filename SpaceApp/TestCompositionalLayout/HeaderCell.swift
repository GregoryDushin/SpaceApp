//
//  HeaderCell.swift
//  SpaceApp
//
//  Created by Григорий Душин on 07.11.2022.
//

import UIKit

class HeaderCell: UICollectionReusableView {
        
    @IBOutlet var hui: UILabel!
 
    func setup(title: String) {
        hui.text = title
    }
}
