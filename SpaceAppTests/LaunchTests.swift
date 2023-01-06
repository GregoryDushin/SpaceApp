//
//  LaunchTests.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 22.12.2022.
//

import XCTest
@testable import SpaceApp

class MockLaunchNetworkManager: LaunchLoaderProtocol {

    let data: [LaunchModelElement] = [LaunchModelElement(success: true, name: "TestName", dateUtc: Date(timeIntervalSince1970: .pi), rocket: "TestRocket")]

    func launchDataLoad(id: String, completion: @escaping (Result<[LaunchModelElement], Error>) -> Void) {
        completion(.success(data))
    }
}

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
        presenter = LaunchPresenter(launchLoader: MockLaunchNetworkManager(), id: "5e9d0d95eda69955f709d1eb")
        presenter.view = view
    }

    override func tearDownWithError() throws {
        view = nil
        presenter = nil
    }

    func testRocketIsNotNil() {
        XCTAssertNotNil(view, "view is not nil")
        XCTAssertNotNil(presenter, "presenter is not nil")
    }

    func testLaunchView() async throws {
        let exp = expectation(description: "Loading data")

        presenter.getData()
        exp.fulfill()

        await waitForExpectations(timeout: 3)

        XCTAssertEqual(view.titleTest, "TestName")
    }
}
