//
//  SettingsTests.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 22.12.2022.
//

import XCTest
@testable import SpaceApp

final class SettingsTests: XCTestCase {

    private var mockView: MockSettingsView!
    private var presenter: SettingsPresenter!
    private var testArrayForComparingData = [Setting]()
    private var settingsWereUpdated = false

    override func setUp() {
        mockView = MockSettingsView()
        settingsWereUpdated = false
        presenter = SettingsPresenter(onUpdateSetting: { [weak self] in self?.settingsWereUpdated = true })

        // MARK: не увидел проблем с trailing_closure  ???

        presenter.view = mockView
        testArrayForComparingData = [
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
    }

    override func tearDown() {
        mockView = nil
        presenter = nil
    }

    func testGetDataShowsData() {
        presenter.showData()
        XCTAssertEqual(mockView.dataFromPresenter?.count, testArrayForComparingData.count)
    }

    func testSaveDataWriteToUserDefaults() {
        let settings = [
            PersistancePositionKeys.heightPositionKey,
            PersistancePositionKeys.diameterPositionKey,
            PersistancePositionKeys.massPositionKey,
            PersistancePositionKeys.capacityPositionKey
        ]
            .enumerated()
            .forEach {
                presenter.saveData(selectedIndex: $0.offset, indexPath: $0.offset)
                XCTAssertEqual(UserDefaults.standard.string(forKey: $0.element), "\($0.offset)")
            }

        XCTAssertTrue(settingsWereUpdated)
    }
}

private extension SettingsTests {

    final class MockSettingsView: SettingsViewProtocol {

        var dataFromPresenter: [Setting]?

        func present(data: [Setting]) {
            dataFromPresenter = data
        }
    }
}
