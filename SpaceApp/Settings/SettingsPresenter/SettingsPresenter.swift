//
//  SettingsPresenter.swift
//  SpaceApp
//
//  Created by Григорий Душин on 05.12.2022.
//

import Foundation

protocol SettingsViewProtocol: AnyObject {
    func present(data: [Setting])
}

protocol SettingsViewPresenterProtocol: AnyObject {
    func showData()
    func saveData(selectedIndex: Int, indexPath: Int)
    var view: SettingsViewProtocol? { get set }
}

final class SettingsPresenter: SettingsViewPresenterProtocol {

    weak var view: SettingsViewProtocol?
    private let defaults = UserDefaults.standard
    private let onUpdateSetting: (() -> Void)

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

    init (onUpdateSetting: @escaping (() -> Void)) {
        self.onUpdateSetting = onUpdateSetting
    }

    func saveData(selectedIndex: Int, indexPath: Int) {
        defaults.set(selectedIndex, forKey: settingsArray[indexPath].positionKey)
        onUpdateSetting()
    }

    func showData() {
        self.view?.present(data: settingsArray)
    }
}
