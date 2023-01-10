//
//  LaunchTests.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 22.12.2022.
//

import XCTest
@testable import SpaceApp

final class LaunchTests: XCTestCase {

    private var view: MockLaunchView!
    private var presenter: LaunchPresenter!
    private var testData: [LaunchData]?

    override func setUp() {
        view = MockLaunchView()
        presenter = LaunchPresenter(launchLoader: MockLaunchNetworkManager(), id: "test")
        presenter.view = view
        testData = [
            LaunchData(
                name: "TestName",
                date: "01/01/70",
                image: UIImage.named(LaunchImages.success)
            )
        ]
    }

    override func tearDown() {
        view = nil
        presenter = nil
    }

    func testLaunchView() async {
        let exp = expectation(description: "Loading data")

        presenter.getData()
        exp.fulfill()

        await waitForExpectations(timeout: 3)

        XCTAssertEqual(view.testArray, testData)
        XCTAssertNil(view.testError)
    }
}

private extension LaunchTests {

    final class MockLaunchNetworkManager: LaunchLoaderProtocol {

        private let data: [LaunchModelElement] = [
            LaunchModelElement(
                success: true,
                name: "TestName",
                dateUtc: Date(timeIntervalSince1970: .pi),
                rocket: "TestRocket"
            )
        ]

        func launchDataLoad(id: String, completion: @escaping (Result<[LaunchModelElement], Error>) -> Void) {
            completion(.success(data))
        }
    }

   final class MockLaunchView: LaunchViewProtocol {

        var testArray: [LaunchData]?
        var testError: Error?

        func failure(error: Error) {
            testError = error
        }

        func success(data: [LaunchData]) {
            testArray = data
        }
    }

}
