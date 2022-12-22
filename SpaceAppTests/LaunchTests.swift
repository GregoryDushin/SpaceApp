//
//  LaunchTests.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 22.12.2022.
//

import XCTest
@testable import SpaceApp

class MockLaunchView: LaunchViewProtocol {
    var titleTest: String?

    func failure(error: Error) {
        titleTest = "failure"
    }

    func success(data: [LaunchData]) {
        titleTest = data[0].name
    }
}

class LaunchTests: XCTestCase {
    var view: MockLaunchView!
    var presenter: LaunchPresenter!

    override func setUpWithError() throws {
        view = MockLaunchView()
        presenter = LaunchPresenter(launchLoader: LaunchLoader(), id: "5e9d0d95eda69973a809d1ec") // id для Falcon 1
        presenter.view = view
    }

    override func tearDownWithError() throws {
        view = nil
        presenter = nil
    }

    func testLaunchViewIsNotNil() {
        XCTAssertNotNil(view, "view is not nil")
        XCTAssertNotNil(presenter, "presenter is not nil")
    }

    func testLaunchView() {
        presenter.getData()
        XCTAssertEqual(view.titleTest, "Falcon 1")   // так же nil???
    }
}
