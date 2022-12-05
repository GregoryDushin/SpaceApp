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

    init?(coder: NSCoder, completion: (() -> Void)?) {
        self.completion = completion
        super.init(coder: coder)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private let settingsArray = [
        Setting(
            title: "Высота",
            positionKey: PersistancePositionKeys.heightPositionKey,
            values: ["m", "ft"]
        ),
        Setting(
            title: "Диаметр",
            positionKey: PersistancePositionKeys.diameterPositionKey,
            values: ["m", "ft"]
        ),
        Setting(
            title: "Масса",
            positionKey: PersistancePositionKeys.massPositionKey,
            values: ["kg", "lb"]
            ),
        Setting(
            title: "Полезная нагрузка",
            positionKey: PersistancePositionKeys.capacityPositionKey,
            values: ["kg", "lb"]
            )
    ]

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
            self.defaults.set(selectedIndex, forKey: self.settingsArray[indexPath.row].positionKey)
            self.completion?()
        }
        return cell
    }
}
