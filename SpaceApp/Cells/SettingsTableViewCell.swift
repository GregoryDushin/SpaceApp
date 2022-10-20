//
//  SettingsTableViewCell.swift
//  SpaceApp
//
//  Created by Григорий Душин on 17.10.2022.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet var settingsLabel: UILabel!
    @IBOutlet var settingsSegmentedControl: UISegmentedControl!
//    func cellConfigure(settingsNames: [String], settingsValues: [[String]], index: Int) {
//        settingsLabel.text = settingsNames[index]
//        settingsSegmentedControl.setTitle(settingsValues[0], forSegmentAt: 0)
//        settingsSegmentedControl.setTitle(settingsValues[index][1], forSegmentAt: 1)
//    }
    var onSettingChanged: ((Int) -> ())?
}
