//
//  TestRocket.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 21.12.2022.
//

import XCTest
import UIKit
@testable import SpaceApp

final class RocketTest: XCTestCase {

    private var view: MockView!
    private var rocket: RocketModelElement!
    private var presenter: RocketViewPresenter!
    private var testSection: [Section]!

    override func setUp() {
        view = MockView()
        let heightName: String
        let heightValue: String
        let diamName: String
        let diamValue: String
        let massName: String
        let massValue: String
        let capacityName: String
        let capacityValue: String

        if UserDefaults.standard.string(forKey: PersistancePositionKeys.heightPositionKey) == "1" {
            heightName = "Высота, ft"
            heightValue = String(2.0)
        } else {
            heightName = "Высота, m"
            heightValue = String(1.0)
        }

        if UserDefaults.standard.string(forKey: PersistancePositionKeys.diameterPositionKey) == "1" {
            diamName = "Диаметр, ft"
            diamValue = String(2.0)
        } else {
            diamName = "Диаметр, m"
            diamValue = String(1.0)
        }

        if UserDefaults.standard.string(forKey: PersistancePositionKeys.massPositionKey) == "1" {
            massName = "Масса, lb"
            massValue = String(2)
        } else {
            massName = "Масса, kg"
            massValue = String(1)
        }

        if UserDefaults.standard.string(forKey: PersistancePositionKeys.capacityPositionKey) == "1" {
            capacityName = "Масса, lb"
            capacityValue = String(2)
        } else {
            capacityName = "Масса, kg"
            capacityValue = String(1)
        }
        rocket = RocketModelElement(
            height: .init(meters: 1.0, feet: 2.0),
            diameter: .init(meters: 1.0, feet: 2.0),
            mass: .init(kg: 1, lb: 2),
            firstStage: .init(engines: 1, fuelAmountTons: 1, burnTimeSec: 1),
            secondStage: .init(engines: 1, fuelAmountTons: 1, burnTimeSec: 1),
            payloadWeights: [.init(kg: 1, lb: 2)],
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
                sectionType: .image,
                title: nil,
                items: [.image(url: URL(string: "test")!, rocketName: "test")]
            ),
            Section(
                sectionType: .horizontal,
                title: nil,
                items:
                    [
                        .horizontalInfo(
                            title: heightName,
                            value: heightValue
                        ),
                        .horizontalInfo(
                            title: diamName,
                            value: diamValue
                        ),
                        .horizontalInfo(
                            title: massName,
                            value: massValue
                        ),
                        .horizontalInfo(
                            title: capacityName,
                            value: capacityValue
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
                            value: "test"
                        ),
                        .verticalInfo(
                            title: "Страна",
                            value: "США"
                        ),
                        .verticalInfo(
                            title: "Стоимость запуска",
                            value: "$" + String((1) / 1_000_000) + " млн"
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
                            value: String(1)
                        ),
                        .verticalInfo(
                            title: "Количество топлива",
                            value: String(1) + " тонн"
                        ),
                        .verticalInfo(
                            title: "Время сгорания",
                            value: String(1) + " сек"
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
                            value: String(1)
                        ),
                        .verticalInfo(
                            title: "Количество топлива",
                            value: String(1) + " тонн"
                        ),
                        .verticalInfo(
                            title: "Время сгорания",
                            value: String(1) + " сек"
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

    func testRocketView() {

        let defaults = UserDefaults.standard
        defaults.set(1, forKey: PersistancePositionKeys.heightPositionKey)
        defaults.set(1, forKey: PersistancePositionKeys.capacityPositionKey)
        defaults.set(1, forKey: PersistancePositionKeys.diameterPositionKey)
        defaults.set(1, forKey: PersistancePositionKeys.massPositionKey)
        presenter.getData()

        XCTAssertEqual(view.arrayTest.count, testSection.count)

        for  i in 0..<view.arrayTest.count - 1 {
            XCTAssertEqual(view.arrayTest[i].title, testSection[i].title)
            XCTAssertEqual(view.arrayTest[i].sectionType, testSection[i].sectionType)
            XCTAssertEqual(view.arrayTest[i].items.count, testSection[i].items.count)
            let sequence = zip(view.arrayTest[i].items, testSection[i].items)
            for (el1, el2) in sequence {
                switch (el1, el2) {
                case let (.horizontalInfo(title1, value1), .horizontalInfo(title2, value2)):
                    XCTAssertEqual(title1, title2)
                    XCTAssertEqual(value1, value2)
                case let (.verticalInfo(title1, value1, _), .verticalInfo(title2, value2, _)):
                    XCTAssertEqual(title1, title2)
                    XCTAssertEqual(value1, value2)
                case let (.image(url1, rocketName1), .image(url2, rocketName2)):
                    XCTAssertEqual(url1, url2)
                    XCTAssertEqual(rocketName1, rocketName2)
                case (.button, .button):
                    print("hz")

                case (.image(url: let url, rocketName: let rocketName), _):
                    print("hz")
                case (.verticalInfo(title: let title, value: let value, id: let id), _):
                    print("hz")
                case (.horizontalInfo(title: let title, value: let value), _):
                    print("hz")
                case (_, .image(url: let url, rocketName: let rocketName)):
                    print("hz")
                case (_, .verticalInfo(title: let title, value: let value, id: let id)):
                    print("hz")
                case (_, .horizontalInfo(title: let title, value: let value)):
                    print("hz")
                }
            }
        }
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
