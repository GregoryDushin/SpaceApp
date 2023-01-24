//
//  CustomPageViewTests.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 22.12.2022.
//

import XCTest
@testable import SpaceApp

final class CustomPagePresenterTests: XCTestCase {

    private var mockView: MockCustomView!
    private var presenter: CustomPagePresenter!
    private var mockRocket = [RocketModelElement]()
    private var mockError = MockError()
    private var mockRocketNetworkManager: MockRocketNetworkManager!

    override func setUp() {
        mockView = MockCustomView()
        mockRocketNetworkManager = MockRocketNetworkManager()
        presenter = CustomPagePresenter(rocketLoader: mockRocketNetworkManager)
        presenter.view = mockView
        mockRocket = [
            RocketModelElement(
                height: .init(meters: 0.1, feet: 0.1),
                diameter: .init(meters: 0.1, feet: 0.1),
                mass: .init(kg: 1, lb: 1),
                firstStage: .init(engines: 1, fuelAmountTons: 0.1, burnTimeSec: 1),
                secondStage: .init(engines: 1, fuelAmountTons: 0.1, burnTimeSec: 1),
                payloadWeights: [.init(kg: 1, lb: 1)],
                flickrImages: ["TestImg", "TestImg"],
                name: "TestRocket",
                stages: 1,
                costPerLaunch: 1,
                firstFlight: "TestFlight",
                id: "TextId"
            )
        ]
    }

    override func tearDown() {
        mockView = nil
        presenter = nil
        mockRocketNetworkManager = nil
    }

    func testRecievingDataSuccess() {
        mockRocketNetworkManager.mockRocket = mockRocket
        presenter.getData()
        XCTAssertEqual(mockView.dataFromPresenter, mockRocket)
    }

    func testRecievingDataFailure() {
        mockRocketNetworkManager.mockError = mockError
        presenter.getData()
        XCTAssertEqual(mockView.errorFromPresenter, mockError)
    }
}

private extension CustomPagePresenterTests {

    final class MockRocketNetworkManager: RocketLoaderProtocol {

        var mockError: MockError?
        var mockRocket: [RocketModelElement]?

        func rocketDataLoad(completion: @escaping (Result<[RocketModelElement], Error>) -> Void) {
            if let mockRocket = mockRocket {
                completion(.success(mockRocket))
            } else if let mockError = mockError {
                completion(.failure(mockError))
            }
        }
    }

    final class MockCustomView: CustomPageViewProtocol {

        var dataFromPresenter: [RocketModelElement]?
        var errorFromPresenter: MockError?

        func failure(error: Error) {
            self.errorFromPresenter = error as? MockError
        }

        func success(data: [RocketModelElement]) {
            self.dataFromPresenter = data
        }
    }
}
