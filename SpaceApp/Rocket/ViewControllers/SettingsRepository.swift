//
//  SettingsRepository.swift
//  SpaceApp
//
//  Created by Григорий Душин on 13.01.2023.
//

import Foundation

protocol SettingsRepositoryProtocol {
    func `set`(setting: String, value: String)
    func `get`(setting: String) -> String?
}

final class SettingsRepository: SettingsRepositoryProtocol {

    func get(setting: String) -> String? {
        UserDefaults.standard.string(forKey: setting)
    }

    func set(setting: String, value: String) {
        UserDefaults.standard.set(value, forKey: setting)
    }
}
