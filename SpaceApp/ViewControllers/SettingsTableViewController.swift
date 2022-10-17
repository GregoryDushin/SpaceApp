//
//  SettingsTableViewController.swift
//  SpaceApp
//
//  Created by Григорий Душин on 14.10.2022.
//

import UIKit

class SettingsTableViewController: UIViewController {

    @IBOutlet weak var settingsTableView: UITableView!
    
    let settingsArray = ["Высота","Диаметр","Масса","Полезная нагрузка"]
    let settingValues = [["m","ft"],["m","ft"],["kg","lb"],["kg","lb"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
extension SettingsTableViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: "Cell" ) as! SettingsTableViewCell
        cell.settingsLabel.text = settingsArray[indexPath.row]
        cell.settingsSegmentedControl.setTitle(settingValues[indexPath.row ][0], forSegmentAt: 0)
        cell.settingsSegmentedControl.setTitle(settingValues[indexPath.row][1], forSegmentAt: 1)
        return cell
    }
    
    

}
