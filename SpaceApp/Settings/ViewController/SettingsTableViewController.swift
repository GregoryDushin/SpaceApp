//
//  SettingsTableViewController.swift
//  SpaceApp
//
//  Created by Григорий Душин on 14.10.2022.
//

import UIKit

final class SettingsTableViewController: UIViewController {
    @IBOutlet private var settingsTableView: UITableView!

    private var settings: [Setting] = []
    private var presenter: SettingsViewPresenterProtocol

    init?(coder: NSCoder, presenter: SettingsViewPresenterProtocol) {
        self.presenter = presenter
        super.init(coder: coder)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
    }
}

// MARK: - UITableViewDataSource

extension SettingsTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = settingsTableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.reuseIdentifier
        ) as? SettingsTableViewCell else { return UITableViewCell() }

        cell.cellConfigure(settings: settings[indexPath.row])
        cell.onSettingChanged = { [weak self] selectedIndex in
            guard let self = self else { return }
            self.presenter.saveData(selectedIndex: selectedIndex, indexPath: indexPath.row)
        }
        return cell
    }
}
extension SettingsTableViewController: SettingsViewProtocol {
    func present(data: [Setting]) {
        self.settings = data
        self.settingsTableView.reloadData()
    }
}
