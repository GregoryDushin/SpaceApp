//
//@testable import SpaceApp
//import XCTest
//
//final class SettingsRepositoryMock: SettingsRepositoryProtocol {
//    
//    var savedValues = [String: String]()
//
//    func get(setting: String) -> String? {
//        savedValues[setting]
//    }
//
//    func set(setting: String, value: String) {
//        savedValues[setting] = value
//    }
//}
//
//final class RocketTest: XCTestCase {
//
//    private var view: MockView!
//    private var rocket: RocketModelElement!
//    private var presenter: RocketPresenter!
//    private var testSection: [Section]!
//    private var mock = SettingsRepositoryMock()
//
//    override func setUp() {
//        view = MockView()
//        rocket = RocketModelElement(
//            height: .init(meters: 1.0, feet: 2.0),
//            diameter: .init(meters: 1.0, feet: 2.0),
//            mass: .init(kg: 1, lb: 2),
//            firstStage: .init(engines: 1, fuelAmountTons: 1, burnTimeSec: 1),
//            secondStage: .init(engines: 1, fuelAmountTons: 1, burnTimeSec: 1),
//            payloadWeights: [.init(kg: 1, lb: 2)],
//            flickrImages: ["test", "test"],
//            name: "test",
//            stages: 1,
//            costPerLaunch: 1,
//            firstFlight: "test",
//            id: "test"
//        )
//        let mockpresentermockPresenter = RocketPresenter(rocketData: rocket, settingsRepository: mock)
//        presenter.view = view
//        testSection = makeMockedSetctions()
//
//    }
//
//    override func tearDown() {
//        view = nil
//        rocket = nil
//        presenter = nil
//    }
//    func testGetDataMapRocketToSections() {
//        // Given
//
//        // When
//        presenter.getData()
//
//        // Then
//        let expectedSections = makeMockedSetctions()
//        assertEqual(lhs: view.dataFromPresent, rhs: expectedSections)
//    }
//
//    func testHeightSettingChangeUnits() {
//        // Given
//        mock.values[PersistancePositionKeys.heightPositionKey] = "1"
//
//        // When
//        presenter.getData()
//
//        // Then
//        XCTAssertEqual(view.dataFromPresent[5].items[1], .horizontalInfo(title: "Высота", value: "метры"))
//    }
////    func testRocketView() {
////
////        let defaults = UserDefaults.standard
////        defaults.set(1, forKey: PersistancePositionKeys.heightPositionKey)
////        defaults.set(1, forKey: PersistancePositionKeys.capacityPositionKey)
////        defaults.set(1, forKey: PersistancePositionKeys.diameterPositionKey)
////        defaults.set(1, forKey: PersistancePositionKeys.massPositionKey)
////        presenter.getData()
////
////        XCTAssertEqual(view.arrayTest.count, testSection.count)
////
////        for  i in 0..<view.arrayTest.count - 1 {
////            XCTAssertEqual(view.arrayTest[i].title, testSection[i].title)
////            XCTAssertEqual(view.arrayTest[i].sectionType, testSection[i].sectionType)
////            XCTAssertEqual(view.arrayTest[i].items.count, testSection[i].items.count)
////            let sequence = zip(view.arrayTest[i].items, testSection[i].items)
////            for (el1, el2) in sequence {
////                switch (el1, el2) {
////                case let (.horizontalInfo(title1, value1), .horizontalInfo(title2, value2)):
////                    XCTAssertEqual(title1, title2)
////                    XCTAssertEqual(value1, value2)
////                case let (.verticalInfo(title1, value1, _), .verticalInfo(title2, value2, _)):
////                    XCTAssertEqual(title1, title2)
////                    XCTAssertEqual(value1, value2)
////                case let (.image(url1, rocketName1), .image(url2, rocketName2)):
////                    XCTAssertEqual(url1, url2)
////                    XCTAssertEqual(rocketName1, rocketName2)
////                default:
////                    print("hz")
////                }
////            }
////        }
////    }
//}
//
//private extension RocketTest {
//
//    final class MockView: RocketViewProtocol {
//        var arrayTest: [Section]!
//
//        func present(data: [Section]) {
//            self.arrayTest = data
//        }
//    }
//    func makeMockedSetctions() -> [Section] {
//        [
//            Section(
//                sectionType: .image,
//                title: nil,
//                items: [.image(url: URL(string: "test")!, rocketName: "test")]
//            ),
//            Section(
//                sectionType: .horizontal,
//                title: nil,
//                items:
//                    [
//                        .horizontalInfo(
//                            title: "heightName",
//                            value: "heightValue"
//                        ),
//                        .horizontalInfo(
//                            title: "diamName",
//                            value: "diamValue"
//                        ),
//                        .horizontalInfo(
//                            title: "massName",
//                            value: "massValue"
//                        ),
//                        .horizontalInfo(
//                            title: "capacityName",
//                            value: "capacityValue"
//                        )
//                    ]
//            ),
//            Section(
//                sectionType: .vertical,
//                title: nil,
//                items:
//                    [
//                        .verticalInfo(
//                            title: "Первый запуск",
//                            value: "test"
//                        ),
//                        .verticalInfo(
//                            title: "Страна",
//                            value: "США"
//                        ),
//                        .verticalInfo(
//                            title: "Стоимость запуска",
//                            value: "$" + String((1) / 1_000_000) + " млн"
//                        )
//                    ]
//            ),
//            Section(
//                sectionType: .vertical,
//                title: "Первая ступень",
//                items:
//                    [
//                        .verticalInfo(
//                            title: "Количество двигателей",
//                            value: String(1)
//                        ),
//                        .verticalInfo(
//                            title: "Количество топлива",
//                            value: String(1) + " тонн"
//                        ),
//                        .verticalInfo(
//                            title: "Время сгорания",
//                            value: String(1) + " сек"
//                        )
//                    ]
//            ),
//            Section(
//                sectionType: .vertical,
//                title: "Вторая ступень",
//                items:
//                    [
//                        .verticalInfo(
//                            title: "Количество двигателей",
//                            value: String(1)
//                        ),
//                        .verticalInfo(
//                            title: "Количество топлива",
//                            value: String(1) + " тонн"
//                        ),
//                        .verticalInfo(
//                            title: "Время сгорания",
//                            value: String(1) + " сек"
//                        )
//                    ]
//            ),
//            Section(sectionType: .button, title: nil, items: [.button])
//        ]
//    }
//}
