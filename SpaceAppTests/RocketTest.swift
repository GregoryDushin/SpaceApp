
@testable import SpaceApp
import XCTest

final class SettingsRepositoryMock: SettingsRepositoryProtocol {

    var savedValues = [String: String]()

    func get(setting: String) -> String? {
        savedValues[setting]
    }

    func set(setting: String, value: String) {
        savedValues[setting] = value
    }
}

final class RocketTest: XCTestCase {

    private var view: MockView!
    private var rocket: RocketModelElement!
    private var mockPresenter: RocketPresenter!
    private var testSection: [Section]!
    private var mock = SettingsRepositoryMock()

    override func setUp() {
        view = MockView()
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
        mockPresenter = RocketPresenter(rocketData: rocket, settingsRepository: mock)
        mockPresenter.view = view
        testSection = makeMockedSetctions()

    }

    override func tearDown() {
        view = nil
        rocket = nil
        mockPresenter = nil
    }
    func testGetDataMapRocketToSections() {
        // Given

        // When
        mockPresenter.getData()

        // Then
        let expectedSections = makeMockedSetctions()
        assertEqual(lhs: view.dataFromPresent, rhs: expectedSections)
    }

    func testHeightSettingChangeUnits() {
        // Given
        mock.set(setting: PersistancePositionKeys.heightPositionKey, value: "0")
        // When
        mockPresenter.getData()
        // Then
        XCTAssertEqual(view.dataFromPresent[1].items[0], .horizontalInfo(title: "Высота, m", value: "1.0"))
    }

    func testDiametrSettingChangeUnits() {
        // Given
        mock.set(setting: PersistancePositionKeys.diameterPositionKey, value: "0")
        // When
        mockPresenter.getData()

        // Then
        XCTAssertEqual(view.dataFromPresent[1].items[1], .horizontalInfo(title: "Диаметр, m", value: "1.0"))
    }

    func testMassChangeUnits() {
        // Given
        mock.set(setting: PersistancePositionKeys.massPositionKey, value: "0")
        // When
        mockPresenter.getData()
        // Then
        XCTAssertEqual(view.dataFromPresent[1].items[2], .horizontalInfo(title: "Масса, kg", value: "1"))
    }

    func testCapacityChangeUnits() {
        // Given
        mock.set(setting: PersistancePositionKeys.capacityPositionKey, value: "0")
        // When
        mockPresenter.getData()
        // Then
        XCTAssertEqual(view.dataFromPresent[1].items[3], .horizontalInfo(title: "Масса, kg", value: "1"))
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
                default:
                    print("hahaha")
                }
            }
        }
    }
}

private extension RocketTest {

    class MockView: RocketViewProtocol {

        var dataFromPresent = [Section]()

        func present(data: [Section]) {
            self.dataFromPresent = data
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
}
