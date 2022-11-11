//
//  SettingsTableViewController.swift
//  SpaceApp
//
//  Created by Григорий Душин on 14.10.2022.
//

import UIKit

final class SettingsTableViewController: UIViewController {
    @IBOutlet private var settingsTableView: UITableView!
    private let settingsArray = [
        Setting(title: "Высота", key: PersistanceKeys.heightKey, values: ["m", "ft"]),
        Setting(title: "Диаметр", key: PersistanceKeys.diameterKey, values: ["m", "ft"]),
        Setting(title: "Масса", key: PersistanceKeys.massKey, values: ["kg", "lb"]),
        Setting(title: "Полезная нагрузка", key: PersistanceKeys.capacityKey, values: ["kg", "lb"])
    ]
    private var selectedIndexPath: Int = 0
    private let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
    }
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
            withIdentifier: String(describing: SettingsTableViewCell.self)
        ) as? SettingsTableViewCell else { return UITableViewCell() }
        cell.cellConfigure(settings: settingsArray[indexPath.row])
        cell.onSettingChanged = { [self] selectedIndex in
            defaults.set(settingsArray[indexPath.row].values[selectedIndex], forKey: settingsArray[indexPath.row].key)
        }
        return cell
    }
}