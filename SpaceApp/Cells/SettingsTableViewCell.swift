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

    func cellConfigure(settings: Setting) {
        settingsLabel.text = settings.title
        settingsSegmentedControl.setTitle(settings.values[0], forSegmentAt: 0)
        settingsSegmentedControl.setTitle(settings.values[1], forSegmentAt: 1)
        settingsSegmentedControl.addTarget(self, action: #selector(changed), for: .valueChanged)
    }
    var onSettingChanged: ((Int) -> ())?

    @objc private func changed() {
        onSettingChanged?(settingsSegmentedControl.selectedSegmentIndex)
    }
}
