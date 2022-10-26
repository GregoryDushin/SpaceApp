//
//  DataViewController.swift
//  SpaceApp
//
//  Created by Григорий Душин on 18.10.2022.
//

import UIKit

final class DataViewController: UIViewController {
    @IBOutlet var displayLabel: UILabel!
    var displayText: String?
    var index: Int = 0
    var id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLabel.text = displayText
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showLaunch" else { return }
        guard let destination = segue.destination as? LaunchViewController else { return }
        destination.newId = id
        destination.title = displayText
    }
}
