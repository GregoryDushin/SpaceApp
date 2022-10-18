//
//  SettingsTableViewController.swift
//  SpaceApp
//
//  Created by Григорий Душин on 14.10.2022.
//

import UIKit

class SettingsTableViewController: UIViewController {
    @IBAction func switchSettings(_ sender: Any) {
    }
    @IBOutlet weak var settingsTableView: UITableView!
    var selectedIndexPath: Int = 0
    let settingsArray = ["Высота", "Диаметр", "Масса", "Полезная нагрузка"]
    let settingValues = [["m", "ft"], ["m", "ft"], ["kg", "lb"], ["kg", "lb"]]
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @objc func segmentAction(sender: UISegmentedControl) {
        let text = sender.titleForSegment(at: sender.selectedSegmentIndex)
        switch selectedIndexPath {
        case 0:
            defaults.set(text, forKey: "Persistance.heightKey")
        case 1:
            defaults.set(text, forKey: "Persistance.diameter")
        case 2:
            defaults.set(text, forKey: "Persistance.mass")
        case 3:
            defaults.set(text, forKey: "Persistance.capacity")
        default:
            print("error")
        }
    }
}

extension SettingsTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: "Cell" ) as! SettingsTableViewCell
        cell.settingsLabel.text = settingsArray[indexPath.row]
        cell.settingsSegmentedControl.setTitle(settingValues[indexPath.row ][0], forSegmentAt: 0)
        cell.settingsSegmentedControl.setTitle(settingValues[indexPath.row][1], forSegmentAt: 1)
        cell.onSettingChanged = { [self] selectedIndex in
            self.selectedIndexPath = selectedIndex
        }
        cell.settingsSegmentedControl.addTarget(self, action: #selector (segmentAction), for: .valueChanged)
        return cell
    }
}
