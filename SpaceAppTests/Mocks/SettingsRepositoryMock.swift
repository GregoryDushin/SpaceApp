//
//  SettingsMock.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 24.01.2023.
//

@testable import SpaceApp
import XCTest

final class SettingsRepositoryMock: SettingsRepositoryProtocol {

    var savedValues = [String: String]()
    var valuesToReturn = [String: String]()

    func get(setting: String) -> String? {
        valuesToReturn[setting]
    }

    func set(setting: String, value: String) {
        savedValues[setting] = value
    }
}
