//
//  CustomPageViewTests.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 22.12.2022.
//

import XCTest
@testable import SpaceApp

final class CustomPageTests: XCTestCase {

    private var mockView: MockCustomView!
    private var presenter: CustomPagePresenter!
    private var rocketArrayForComparingData = [RocketModelElement]()
    private var errorForComparing = TestError()

    override func setUp() {
        mockView = MockCustomView()
        presenter = CustomPagePresenter(rocketLoader: MockRocketNetworkManager())
        presenter.view = mockView
        rocketArrayForComparingData = [
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
    }

    func testRecievingDataFromMockRocketNetworkManager() {

        presenter.getData()

        XCTAssertEqual(mockView.dataFromPresenter, rocketArrayForComparingData)
        XCTAssertEqual(mockView.errorFromPresenter, errorForComparing)
    }
}

private extension CustomPageTests {

    final class MockRocketNetworkManager: RocketLoaderProtocol {

        private let mockErrorForTesting = TestError()
        private let mockRocket: [RocketModelElement] = [
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

        func rocketDataLoad(completion: @escaping (Result<[RocketModelElement], Error>) -> Void) {
            completion(.success(mockRocket))
            completion(.failure(mockErrorForTesting))
        }
    }

    final class MockCustomView: CustomPageViewProtocol {

        var dataFromPresenter: [RocketModelElement]?
        var errorFromPresenter: TestError?

        func failure(error: Error) {
            self.errorFromPresenter = error as? TestError
        }

        func success(data: [RocketModelElement]) {
            self.dataFromPresenter = data
        }
    }
}
