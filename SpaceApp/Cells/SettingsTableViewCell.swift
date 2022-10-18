//
//  SettingsTableViewCell.swift
//  SpaceApp
//
//  Created by Григорий Душин on 17.10.2022.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var settingsSegmentedControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var onSettingChanged : ((Int) -> ())?
}
