//
//  CustomPageViewTests.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 22.12.2022.
//

import XCTest
@testable import SpaceApp

class MockRocketNetworkManager: RocketLoaderProtocol {
    let hueta: [RocketModelElement] = [
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
        completion(.success(hueta))
    }
}

class MockCustomView: CustomPageViewProtocol {

    var titleTest: String?

    func failure(error: Error) {
        print(error.localizedDescription)
    }

    func success(data: [RocketModelElement]) {
        self.titleTest = data[0].name
    }
}

class CustomPageViewTests: XCTestCase {

    var view: MockCustomView!
    var presenter: CustomPagePresenter!

    override func setUpWithError() throws {
        view = MockCustomView()
        presenter = CustomPagePresenter(rocketLoader: MockRocketNetworkManager())
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

    func testCustomPageView() async throws {
        let exp = expectation(description: "Loading data")
        presenter.getData()
        exp.fulfill()

        await waitForExpectations(timeout: 3)

        XCTAssertEqual(view.titleTest, "TestRocket")
    }
}
