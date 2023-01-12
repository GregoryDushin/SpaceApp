//
//  CustomPageViewTests.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 22.12.2022.
//

import XCTest
@testable import SpaceApp

final class CustomPageViewTests: XCTestCase {

    private var view: MockCustomView!
    private var presenter: CustomPagePresenter!
    private var testRocket: [RocketModelElement]?

    override func setUp() {
        view = MockCustomView()
        presenter = CustomPagePresenter(rocketLoader: MockRocketNetworkManager())
        presenter.view = view
        testRocket = [
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
        view = nil
        presenter = nil
    }

    func testCustomPageView() async {
        
        let exp = expectation(description: "Loading data")
        presenter.getData()
        XCTAssertEqual(view.testArray, testRocket)
        XCTAssertNil(view.error)
        exp.fulfill()
        
        await waitForExpectations(timeout: 3)
        
    }
}

private extension CustomPageViewTests {

    final class MockRocketNetworkManager: RocketLoaderProtocol {

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
        }
    }

    final class MockCustomView: CustomPageViewProtocol {

        private var titleTest: String?
        var testArray: [RocketModelElement]?
        var error: Error?

        func failure(error: Error) {
            self.error = error
        }

        func success(data: [RocketModelElement]) {
            self.testArray = data
        }
    }
}
