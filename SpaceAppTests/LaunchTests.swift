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
    private var testData = [LaunchData]()

    override func setUp() {
        mockView = MockLaunchView()
        presenter = LaunchPresenter(launchLoader: MockLaunchNetworkManager(), id: "test")
        presenter.view = mockView
        testData = [
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

// MARK: Норм ли называть функции в таком формате с такой длиной?
    func testLaunchDataRecievingFromMockLaunchNetworkManagerConverting() async {
        let exp = expectation(description: "Loading data")
        exp.fulfill()
        presenter.getData()
        await waitForExpectations(timeout: 3)

        XCTAssertEqual(mockView.dataFromPresenter, testData)
        XCTAssertNil(mockView.errorFromPresenter)

// MARK: Без идей что еще проверять, если приходит Error. Во вью контроллерах если из лоадера приходит еррор - вылезает алерт, хз как это проверить.

    }
}

private extension LaunchTests {

    final class MockLaunchNetworkManager: LaunchLoaderProtocol {

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
        }
    }

   final class MockLaunchView: LaunchViewProtocol {

        var dataFromPresenter: [LaunchData]?
        var errorFromPresenter: Error?

        func failure(error: Error) {
            errorFromPresenter = error
        }

        func success(data: [LaunchData]) {
            dataFromPresenter = data
        }
    }

}
