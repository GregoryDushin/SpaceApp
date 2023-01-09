//
//  SettingsTests.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 22.12.2022.
//

import XCTest
@testable import SpaceApp

final class SettingsTests: XCTestCase {

    private var view: MockSettingsView!
    private var presenter: SettingsPresenter!
    private var testArray: [Setting]?

    override func setUp() {
        view = MockSettingsView()
        presenter = SettingsPresenter(onUpdateSetting: { })
        presenter.view = view
        testArray = [
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
        view = nil
        presenter = nil
    }

    func testSettingsView() {
        presenter.showData()
        XCTAssertEqual(view.testArray, testArray)
    }
}

private extension SettingsTests {

    final class MockSettingsView: SettingsViewProtocol {
        var titleTest: String?
        var testArray: [Setting]?

        func present(data: [Setting]) {
            testArray = data
        }
    }

}
