//
//  TestRocket.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 21.12.2022.
//

import XCTest
@testable import SpaceApp

final class RocketTest: XCTestCase {

    private var view: MockView!
    private var rocket: RocketModelElement!
    private var presenter: RocketViewPresenter!
    private var testSection: [Section]!

    override func setUp() {
        view = MockView()
        rocket = RocketModelElement(
            height: .init(meters: 0.1, feet: 0.1),
            diameter: .init(meters: 0.1, feet: 0.1),
            mass: .init(kg: 1, lb: 1),
            firstStage: .init(engines: 1, fuelAmountTons: 0.1, burnTimeSec: 1),
            secondStage: .init(engines: 1, fuelAmountTons: 0.1, burnTimeSec: 1),
            payloadWeights: [.init(kg: 1, lb: 1)],
            flickrImages: ["test", "test"],
            name: "test",
            stages: 1,
            costPerLaunch: 1,
            firstFlight: "test",
            id: "test"
        )
        presenter = RocketViewPresenter(rocketData: rocket)
        presenter.view = view

        testSection = [
            Section(
                sectionType: .horizontal,
                title: nil,
                items:
                    [
                        .horizontalInfo(
                            title: "Высота, m",
                            value: "0.1"
                        ),
                        .horizontalInfo(
                            title: "Диаметр, m",
                            value: "0.1"
                        ),
                        .horizontalInfo(
                            title: "Масса, kg",
                            value: "1"
                        ),
                        .horizontalInfo(
                            title: "Масса, kg",
                            value: "1"
                        )
                    ]
            ),
            Section(
                sectionType: .vertical,
                title: nil,
                items:
                    [
                        .verticalInfo(
                            title: "Первый запуск",
                            value: rocket.firstFlight
                        ),
                        .verticalInfo(
                            title: "Страна",
                            value: "США"
                        ),
                        .verticalInfo(
                            title: "Стоимость запуска",
                            value: "$" + String((rocket.costPerLaunch) / 1_000_000) + " млн"
                        )
                    ]
            ),
            Section(
                sectionType: .vertical,
                title: "Первая ступень",
                items:
                    [
                        .verticalInfo(
                            title: "Количество двигателей",
                            value: String(rocket.firstStage.engines)
                        ),
                        .verticalInfo(
                            title: "Количество топлива",
                            value: (NSString(format: "%.0f", rocket.firstStage.fuelAmountTons) as String) + " тонн"
                        ),
                        .verticalInfo(
                            title: "Время сгорания",
                            value: String(rocket.firstStage.burnTimeSec ?? 0) + " сек"
                        )
                    ]
            ),
            Section(
                sectionType: .vertical,
                title: "Вторая ступень",
                items:
                    [
                        .verticalInfo(
                            title: "Количество двигателей",
                            value: String(rocket.secondStage.engines)
                        ),
                        .verticalInfo(
                            title: "Количество топлива",
                            value: (NSString(format: "%.0f", rocket.secondStage.fuelAmountTons) as String) + " тонн"
                        ),
                        .verticalInfo(
                            title: "Время сгорания",
                            value: String(rocket.secondStage.burnTimeSec ?? 0) + " сек"
                        )
                    ]
            ),
            Section(sectionType: .button, title: nil, items: [.button])
        ]
    }

    override func tearDown() {
         view = nil
         rocket = nil
         presenter = nil
    }

    func testView() {
        presenter.getData()
        XCTAssertEqual(view.arrayTest[0].title, testSection[0].title)
        XCTAssertEqual(view.arrayTest[1].sectionType, testSection[0].sectionType)

    }
}

private extension RocketTest {

    final class MockView: RocketViewProtocol {
        var arrayTest: [Section]!

        func present(data: [Section]) {
            self.arrayTest = data
        }
    }
}
