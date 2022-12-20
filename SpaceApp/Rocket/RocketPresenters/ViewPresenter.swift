//
//  RocketViewPresenter.swift
//  SpaceApp
//
//  Created by Григорий Душин on 10.12.2022.
//

import Foundation

protocol RocketViewProtocol: AnyObject {
    func present(data: [Section])
}

protocol RocketViewPresenterProtocol: AnyObject {
    var view: RocketViewProtocol? { get set }
    func getData()
}

final class RocketViewPresenter: RocketViewPresenterProtocol {
    weak var view: RocketViewProtocol?
    var rocket: RocketModelElement

    init(rocketData: RocketModelElement) {
        self.rocket = rocketData
    }

    func getData() {
        let rocket = rocket
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
            heightValue = String(rocket.height.feet ?? 0.0)
        } else {
            heightName = "Высота, m"
            heightValue = String(rocket.height.meters ?? 0.0)
        }

        if UserDefaults.standard.string(forKey: PersistancePositionKeys.diameterPositionKey) == "1" {
            diamName = "Диаметр, ft"
            diamValue = String(rocket.diameter.feet ?? 0.0)
        } else {
            diamName = "Диаметр, m"
            diamValue = String(rocket.diameter.meters ?? 0.0)
        }

        if UserDefaults.standard.string(forKey: PersistancePositionKeys.massPositionKey) == "1" {
            massName = "Масса, lb"
            massValue = String(rocket.mass.lb)
        } else {
            massName = "Масса, кг"
            massValue = String(rocket.mass.kg)
        }

        if UserDefaults.standard.string(forKey: PersistancePositionKeys.capacityPositionKey) == "1" {
            capacityName = "Масса, lb"
            capacityValue = String(rocket.payloadWeights[0].lb)
        } else {
            capacityName = "Масса, кг"
            capacityValue = String(rocket.payloadWeights[0].kg)
        }

        var sections = [
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
        if let url = URL(string: rocket.flickrImages[0]) {
            let section = Section(
                sectionType: .image,
                title: nil,
                items: [.image(url: url, rocketName: rocket.name)]
            )
            sections.insert(section, at: 0)
        }
        self.view?.present(data: sections)
    }
}
