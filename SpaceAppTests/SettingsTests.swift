//
//  SettingsTests.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 22.12.2022.
//

import XCTest
@testable import SpaceApp

class MockSettingsView: SettingsViewProtocol {
    var titleTest: String?

    func present(data: [Setting]) {
        titleTest = data[0].values[0]
    }
}

class SettingsTests: XCTestCase {
    var view: MockSettingsView!
    var presenter: SettingsPresenter!

    override func setUpWithError() throws {
        view = MockSettingsView()
        presenter = SettingsPresenter(onUpdateSetting: { })
        presenter.view = view
    }

    override func tearDownWithError() throws {
        view = nil
        presenter = nil
    }

    func testSettingsIsNotNil() {
        XCTAssertNotNil(view, "view is not nil")
        XCTAssertNotNil(presenter, "presenter is not nil")
    }

    func testSettingsView() {
        presenter.showData()
        XCTAssertEqual(view.titleTest, "m")
    }
}
