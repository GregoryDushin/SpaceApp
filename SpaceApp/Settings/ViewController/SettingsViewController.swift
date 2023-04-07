//
//  SettingsTableViewController.swift
//  SpaceApp
//
//  Created by Григорий Душин on 14.10.2022.
//

import UIKit

final class SettingsViewController: UIViewController {

    @IBOutlet private var settingsTableView: UITableView!

    private var settings: [Setting] = []
    private var presenter: SettingsViewPresenterProtocol

    init?(coder: NSCoder, presenter: SettingsViewPresenterProtocol) {
        self.presenter = presenter
        super.init(coder: coder)
        presenter.view = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.showData()
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = settingsTableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.reuseIdentifier
        ) as? SettingsTableViewCell else { return UITableViewCell() }

        cell.cellConfigure(settings: settings[indexPath.row])
        cell.onSettingChanged = { [weak self] selectedIndex in
            self?.presenter.saveData(selectedIndex: selectedIndex, indexPath: indexPath.row)
        }

        return cell 
    }
}

// MARK: - SettingsViewProtocol

extension SettingsViewController: SettingsViewProtocol {
    func present(data: [Setting]) {
        self.settings = data
        self.settingsTableView.reloadData()
    }
}
