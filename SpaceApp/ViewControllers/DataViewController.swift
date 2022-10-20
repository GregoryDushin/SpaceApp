//
//  DataViewController.swift
//  SpaceApp
//
//  Created by Григорий Душин on 18.10.2022.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet var displayLabel: UILabel!
    var displayText: String?
    var index: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLabel.text = displayText
    }
}
