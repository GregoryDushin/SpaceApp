//
//  SettingsRepository.swift
//  SpaceApp
//
//  Created by Григорий Душин on 13.01.2023.
//

import Foundation

final class SettingsRepository: SettingsRepositoryProtocol {
  //  var values = [String: String]()
    var savedValues = [String: String]()

    func get(setting: String) -> String? {
        savedValues[setting]
    }

    func set(setting: String, value: String) {
        savedValues[setting] = value
    }
}
