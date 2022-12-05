//
//  SettingsPresenter.swift
//  SpaceApp
//
//  Created by Григорий Душин on 05.12.2022.
//

import Foundation

protocol SettingsViewProtocol: AnyObject {
}

protocol SettingsViewPresenterProtocol: AnyObject {
    func saveData(selectedIndex: Int, indexPath: Int)
    var view: SettingsViewProtocol? { get set }
}

final class SettingsPresenter: SettingsViewPresenterProtocol {
    weak var view: SettingsViewProtocol?

    var settings = Setting.settingsArray
    let defaults = UserDefaults.standard
    let selected: Int
    let index: Int
    var completion: (() -> Void)?

    required init (selected: Int, index: Int) {
        self.selected = selected
        self.index = index
        saveData(selectedIndex: selected, indexPath: index)
    }

    func saveData(selectedIndex: Int, indexPath: Int) {
        defaults.set(selectedIndex, forKey: settings[indexPath].positionKey)
        completion?()
    }
}
