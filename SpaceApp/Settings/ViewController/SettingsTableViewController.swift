//
//  SettingsTableViewController.swift
//  SpaceApp
//
//  Created by Григорий Душин on 14.10.2022.
//

import UIKit

final class SettingsTableViewController: UIViewController {

    @IBOutlet private var settingsTableView: UITableView!

    var completion: (() -> Void)?

    private let settingsArray = [
        Setting(
            title: "Высота",
            key: PersistanceKeys.heightKey,
            positionKey: PersistancePositionKeys.heightPositionKey,
            values: ["m", "ft"]
        ),
        Setting(
            title: "Диаметр",
            key: PersistanceKeys.diameterKey,
            positionKey: PersistancePositionKeys.diameterPositionKey,
            values: ["m", "ft"]
        ),
        Setting(
            title: "Масса",
            key: PersistanceKeys.massKey,
            positionKey: PersistancePositionKeys.massPositionKey,
            values: ["kg", "lb"]
            ),
        Setting(
            title: "Полезная нагрузка",
            key: PersistanceKeys.capacityKey,
            positionKey: PersistancePositionKeys.capacityPositionKey,
            values: ["kg", "lb"]
            )
    ]
    private var selectedIndexPath: Int = 0
    private let defaults = UserDefaults.standard
}

// MARK: - UITableViewDataSource

extension SettingsTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingsArray.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = settingsTableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.reuseIdentifier
        ) as? SettingsTableViewCell else { return UITableViewCell()
        }

        cell.cellConfigure(settings: settingsArray[indexPath.row])
        cell.onSettingChanged = { [weak self] selectedIndex in
            guard let self = self else { return }
            self.defaults.set(self.settingsArray[indexPath.row].values[selectedIndex], forKey: self.settingsArray[indexPath.row].key)
            self.defaults.set(selectedIndex, forKey: self.settingsArray[indexPath.row].positionKey)
            self.completion?()
        }
        return cell
    }
}
