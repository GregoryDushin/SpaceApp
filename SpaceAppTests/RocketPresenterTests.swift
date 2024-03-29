//
//  CustomPageViewTests.swift
//  SpaceAppTests
//
//  Created by Григорий Душин on 22.12.2022.
//

@testable import SpaceApp
import XCTest

final class RocketPresenterTests: XCTestCase {

    private var mockView: MockView!
    private var mockRocket: RocketModelElement!
    private var presenter: RocketPresenter!
    private var mockSection = [Section]()
    private var settingsRepositryMock: SettingsRepositoryMock!

    override func setUp() {
        mockView = MockView()
        mockRocket = RocketModelElement(
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
        settingsRepositryMock = SettingsRepositoryMock()
        presenter = RocketPresenter(rocketData: mockRocket, settingsRepository: settingsRepositryMock)
        presenter.view = mockView
        mockSection = makeMockedSetctions()
    }

    override func tearDown() {
        mockView = nil
        presenter = nil
        settingsRepositryMock = nil
    }

    func testGetDataMapRocketToSections() {
        presenter.getData()
        let expectedSections = makeMockedSetctions()
        assertEqual(lhs: mockView.dataFromPresenter, rhs: expectedSections)
    }

    func testHeightSettingChangeUnitsInMeters() {
        settingsRepositryMock.valuesToReturn[PersistancePositionKeys.heightPositionKey] = "0"
        presenter.getData()
        XCTAssertEqual(mockView.dataFromPresenter[1].items[0], .horizontalInfo(title: "Высота, m", value: "1.0"))
    }

    func testHeightSettingChangeUnitsInFeets() {
        settingsRepositryMock.valuesToReturn[PersistancePositionKeys.heightPositionKey] = "1"
        presenter.getData()
        XCTAssertEqual(mockView.dataFromPresenter[1].items[0], .horizontalInfo(title: "Высота, ft", value: "2.0"))
    }

    func testDiametrSettingChangeUnitsInMeters() {
        settingsRepositryMock.valuesToReturn[PersistancePositionKeys.diameterPositionKey] = "0"
        presenter.getData()
        XCTAssertEqual(mockView.dataFromPresenter[1].items[1], .horizontalInfo(title: "Диаметр, m", value: "1.0"))
    }

    func testDiametrSettingChangeUnitsInFeets() {
        settingsRepositryMock.valuesToReturn[PersistancePositionKeys.diameterPositionKey] = "1"
        presenter.getData()
        XCTAssertEqual(mockView.dataFromPresenter[1].items[1], .horizontalInfo(title: "Диаметр, ft", value: "2.0"))
    }

    func testMassSettingChangeUnitsInKilograms() {
        settingsRepositryMock.valuesToReturn[PersistancePositionKeys.massPositionKey] = "0"
        presenter.getData()
        XCTAssertEqual(mockView.dataFromPresenter[1].items[2], .horizontalInfo(title: "Масса, kg", value: "1"))
    }

    func testMassSettingChangeUnitsInPounds() {
        settingsRepositryMock.valuesToReturn[PersistancePositionKeys.massPositionKey] = "1"
        presenter.getData()
        XCTAssertEqual(mockView.dataFromPresenter[1].items[2], .horizontalInfo(title: "Масса, lb", value: "2"))
    }

    func testCapacitySettingChangeUnitsInKilograms() {

        settingsRepositryMock.valuesToReturn[PersistancePositionKeys.capacityPositionKey] = "0"
        presenter.getData()
        XCTAssertEqual(mockView.dataFromPresenter[1].items[3], .horizontalInfo(title: "Масса, kg", value: "1"))
    }

    func testCapacitySettingChangeUnitsInPounds() {

        settingsRepositryMock.valuesToReturn[PersistancePositionKeys.capacityPositionKey] = "1"
        presenter.getData()
        XCTAssertEqual(mockView.dataFromPresenter[1].items[3], .horizontalInfo(title: "Масса, lb", value: "2"))
    }

    func assertEqual(lhs: [Section], rhs: [Section]) {
        for (lhsSection, rhsSection) in zip(lhs, rhs) {
            XCTAssertEqual(lhsSection.title, rhsSection.title)
            XCTAssertEqual(lhsSection.sectionType, rhsSection.sectionType)
            XCTAssertEqual(lhsSection.items.count, rhsSection.items.count)

            for (lhsItem, rhsItem) in  zip(lhsSection.items, rhsSection.items) {
                switch (lhsItem, rhsItem) {
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
                    continue
                default:
                    XCTFail("Unknown item was found")
                }
            }
        }
    }
}

private extension RocketPresenterTests {

    final class MockView: RocketViewProtocol {

        var dataFromPresenter = [Section]()

        func present(data: [Section]) {
            self.dataFromPresenter = data
        }
    }

    func makeMockedSetctions() -> [Section] {
        [
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
                            title: "Высота, m",
                            value: "1.0"
                        ),
                        .horizontalInfo(
                            title: "Диаметр, m",
                            value: "1.0"
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
                            value: "test"
                        ),
                        .verticalInfo(
                            title: "Страна",
                            value: "США"
                        ),
                        .verticalInfo(
                            title: "Стоимость запуска",
                            value: "$0 млн"
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
                            value: "1"
                        ),
                        .verticalInfo(
                            title: "Количество топлива",
                            value: "1 тонн"
                        ),
                        .verticalInfo(
                            title: "Время сгорания",
                            value: "1 сек"
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
                            value: "1"
                        ),
                        .verticalInfo(
                            title: "Количество топлива",
                            value: "1 тонн"
                        ),
                        .verticalInfo(
                            title: "Время сгорания",
                            value: "1 сек"
                        )
                    ]
            ),
            Section(sectionType: .button, title: nil, items: [.button])
        ]
    }
}
