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

    private let defaults = UserDefaults.standard
  //  private var presenter: SettingsViewPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
            //presenter.view = self
    }
}

// MARK: - UITableViewDataSource

extension SettingsTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Setting.settingsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = settingsTableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.reuseIdentifier
        ) as? SettingsTableViewCell else { return UITableViewCell() }

        cell.cellConfigure(settings: Setting.settingsArray[indexPath.row])
        cell.onSettingChanged = { [weak self] selectedIndex in
            guard let self = self else { return }
//            self.presenter?.saveData(selectedIndex: selectedIndex, indexPath: indexPath.row)
            self.defaults.set(selectedIndex, forKey: Setting.settingsArray[indexPath.row].positionKey)
            self.completion?()
        }
        return cell
    }
}
extension SettingsTableViewController: SettingsViewProtocol {

}
