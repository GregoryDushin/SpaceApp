//
//  TestRocket.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 21.12.2022.
//

import XCTest
@testable import SpaceApp

class MockView: RocketViewProtocol {
    var titleTest: String?

    func present(data: [Section]) {
        self.titleTest = data[3].title
    }
}

class RocketTest: XCTestCase {

    var view: MockView!
    var rocket: RocketModelElement!
    var presenter: RocketViewPresenter!

    override func setUpWithError() throws {
        view = MockView()
        rocket = RocketModelElement(
            height: .init(meters: 0.1, feet: 0.1),
            diameter: .init(meters: 0.1, feet: 0.1),
            mass: .init(kg: 1, lb: 1),
            firstStage: .init(engines: 1, fuelAmountTons: 0.1, burnTimeSec: 1),
            secondStage: .init(engines: 1, fuelAmountTons: 0.1, burnTimeSec: 1),
            payloadWeights: [.init(id: "hui", name: "hui", kg: 1, lb: 1)],
            flickrImages: ["hui", "hui"],
            name: "hui",
            stages: 1,
            costPerLaunch: 1,
            successRatePct: 1,
            firstFlight: "hui",
            id: "hui"
        )
        presenter = RocketViewPresenter(rocketData: rocket)
        presenter.view = view
    }

    override func tearDownWithError() throws {
         view = nil
         rocket = nil
         presenter = nil
    }

    func testRocketIsNotNil() {
        XCTAssertNotNil(view, "view is not nil")
        XCTAssertNotNil(presenter, "presenter is not nil")
        XCTAssertNotNil(rocket, "rocket is not nil")
    }

    func testView() {
        presenter.getData()
        XCTAssertEqual(view.titleTest, "Первая ступень")
    }
}
