//
//  LaunchTests.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 22.12.2022.
//

import XCTest
@testable import SpaceApp

final class LaunchTests: XCTestCase {

    private var mockView: MockLaunchView!
    private var presenter: LaunchPresenter!
    private var launchDataForComparing = [LaunchData]()
    private var mockErrorForComparing = TestError()

    override func setUp() {
        mockView = MockLaunchView()
        presenter = LaunchPresenter(launchLoader: MockLaunchNetworkManager(), id: "test")
        presenter.view = mockView
        launchDataForComparing = [
            LaunchData(
                name: "TestName",
                date: "01/01/70",
                image: UIImage.named(LaunchImages.success)
            )
        ]
    }

    override func tearDown() {
        mockView = nil
        presenter = nil
    }

    func testLaunchDataRecieveFromMockLaunchNetworkManagerConverting() async {
        let exp = expectation(description: "Loading data")
        presenter.getData()
        exp.fulfill()
        await waitForExpectations(timeout: 3)

        XCTAssertEqual(mockView.dataFromPresenter, launchDataForComparing)
        XCTAssertEqual(mockView.errorFromPresenter, mockErrorForComparing)

    }
}

extension LaunchTests {

    final class MockLaunchNetworkManager: LaunchLoaderProtocol {

        private let mockErrorForTesting = TestError()
        private let mockData: [LaunchModelElement] = [
            LaunchModelElement(
                success: true,
                name: "TestName",
                dateUtc: Date(timeIntervalSince1970: .pi),
                rocket: "TestRocket"
            )
        ]

        func launchDataLoad(id: String, completion: @escaping (Result<[LaunchModelElement], Error>) -> Void) {
            completion(.success(mockData))
            completion(.failure(mockErrorForTesting))
        }
    }

    final class MockLaunchView: LaunchViewProtocol {

        var dataFromPresenter: [LaunchData]?
        var errorFromPresenter: TestError?

        func failure(error: Error) {
            errorFromPresenter = error as? TestError
        }

        func success(data: [LaunchData]) {
            dataFromPresenter = data
        }
    }
}

struct TestError: Error, Equatable {
}
