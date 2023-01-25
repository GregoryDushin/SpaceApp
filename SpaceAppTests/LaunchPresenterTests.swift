//
//  LaunchTests.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 22.12.2022.
//

import XCTest
@testable import SpaceApp

final class LaunchPresenterTests: XCTestCase {

    private var mockView: MockLaunchView!
    private var presenter: LaunchPresenter!
    private var mockLaunchData = [LaunchData]()
    private var mockLaunchNetworkData = [LaunchModelElement]()
    private var mockError = ErrorMock()
    private var mockLaunchNetworkManager: MockLaunchNetworkManager!

    override func setUp() {
        mockView = MockLaunchView()
        mockLaunchNetworkManager = MockLaunchNetworkManager()
        presenter = LaunchPresenter(launchLoader: mockLaunchNetworkManager, id: "test")
        presenter.view = mockView
        mockLaunchData = [
            LaunchData(
                name: "TestName",
                date: "01/01/70",
                image: UIImage.named(LaunchImages.success)
            )
        ]
        mockLaunchNetworkData = [
            LaunchModelElement(
                success: true,
                name: "TestName",
                dateUtc: Date(timeIntervalSince1970: .pi),
                rocket: "TestRocket"
            )
        ]
    }

    override func tearDown() {
        mockView = nil
        presenter = nil
        mockLaunchNetworkManager = nil
    }

    func testRecievingDataSuccess() {
        mockLaunchNetworkManager.mockData = mockLaunchNetworkData
        presenter.getData()
        XCTAssertEqual(mockView.dataFromPresenter, mockLaunchData)
    }

    func testRecievingDataFailure() {
        mockLaunchNetworkManager.mockError = mockError
        presenter.getData()
        XCTAssertEqual(mockView.errorFromPresenter, mockError)
    }
}

extension LaunchPresenterTests {

    final class MockLaunchNetworkManager: LaunchLoaderProtocol {

        var mockError: ErrorMock?
        var mockData: [LaunchModelElement]?

        func launchDataLoad(id: String, completion: @escaping (Result<[LaunchModelElement], Error>) -> Void) {
            if let mockData = mockData {
                completion(.success(mockData))
            } else if let mockError = mockError {
                completion(.failure(mockError))
            }
        }
    }

    final class MockLaunchView: LaunchViewProtocol {

        var dataFromPresenter: [LaunchData]?
        var errorFromPresenter: ErrorMock?

        func failure(error: Error) {
            errorFromPresenter = error as? ErrorMock
        }

        func success(data: [LaunchData]) {
            dataFromPresenter = data
        }
    }
}
