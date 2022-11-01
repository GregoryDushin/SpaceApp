//
//  DataViewController.swift
//  SpaceApp
//
//  Created by Григорий Душин on 18.10.2022.
//

import UIKit

final class DataViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!

    var displayText: String?
    var index: Int = 0
    var id = ""
    var dataArray: [RocketModelElement] = []


    let sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = createLayout()
        mapRocketToSections(rocket: dataArray[index])
        collectionView.reloadData()
    }

    // MARK: - Creating sections using CompositionalLayout

    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout {[weak self] sectionIndex, _ in
            guard let self = self else {
                return nil
            }
            let sections = self.sections[sectionIndex]
            switch sections.numberOfSection {
            case 1:
                // item
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                // group
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(425), heightDimension: .absolute(425)), subitems: [item])
                // section
                return NSCollectionLayoutSection(group: group)
            case 2:
                // item
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                // group
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), subitems: [item])
                // section
                return NSCollectionLayoutSection(group: group)
            case 3:
                // item
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                // group
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(150)), subitems: [item])
                // section
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 5
                section.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
                return section
            case 4:
                // item
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
                // group
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(130)), subitems: [item])
                // section
                return NSCollectionLayoutSection(group: group)
            case 5:
                // item
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
                // group
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(130)), subitems: [item])
                // section
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                return section
            case 6:
                // item
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
                // group
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(130)), subitems: [item])
                // section
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                return section
            case .7:
                // item
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                // group
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), subitems: [item])
                // section
                return NSCollectionLayoutSection(group: group)

            }
        }
    }

   private func mapRocketToSections(rocket: RocketModelElement) -> [Section] {
            [
                Section(sectionType: .image, title: nil, items: [.image(URL(fileURLWithPath: rocket.flickrImages[0])), .title(rocket.name)], numberOfSection: 1),
                Section(sectionType: .horizontal, title: nil, items:
                            [.info(title: "Высота", value: String(rocket.height.meters!)),
                             .info(title: "Диаметр", value: String(rocket.diameter.meters!)),
                             .info(title: "Масса", value: String(rocket.mass.kg)),
                             .info(title: "Масса", value: String(rocket.payloadWeights[0].kg))
                            ], numberOfSection: 2),
                Section(sectionType: .vertical, title: nil, items:
                            [.info(title: "Первый запуск", value: rocket.firstFlight),
                             .info(title: "Страна", value: "США"),
                             .info(title: "Стоимость запуска", value: String(rocket.costPerLaunch))
                            ], numberOfSection: 3),
                Section(sectionType: .vertical, title: nil, items:
                            [.info(title: "Количество двигателей", value: String(rocket.firstStage.engines)),
                             .info(title: "Количество топлива", value: String(rocket.firstStage.fuelAmountTons)),
                             .info(title: "Время сгорания", value: String(rocket.firstStage.burnTimeSEC!))
                            ], numberOfSection: 4),
                Section(sectionType: .vertical, title: nil, items:
                            [.info(title: "Количество двигателей", value: String(rocket.secondStage.engines)),
                             .info(title: "Количество топлива", value: String(rocket.secondStage.fuelAmountTons)),
                             .info(title: "Время сгорания", value: String(rocket.secondStage.burnTimeSEC!))
                            ], numberOfSection: 5),
                Section(sectionType: .vertical, title: nil, items: [.button(title: "Launches")], numberOfSection: 6)
            ]
        }


    // MARK: - Creating section headers

    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }

    // MARK: - Data transfer to the launch VC

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showLaunch" else { return }
        guard let destination = segue.destination as? LaunchViewController else { return }
        destination.newId = id
        destination.title = displayText
    }
}

// MARK: - UICollectionViewDataSource

extension DataViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section].numberOfSection {
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RocketImageCell.self), for: indexPath) as! RocketImageCell
            cell.setup(title: sections[indexPath.section].items[0])
           
            return cell

            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RocketNameCell.self), for: indexPath) as! RocketNameCell
            cell.setup(title: dataArray[index].name)
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RocketDescriptionCell.self), for: indexPath) as! RocketDescriptionCell
            cell.setup(title1: items[indexPath.row].title1, title2: items[indexPath.row].title2)
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 12
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RocketAnotherInfoCell.self), for: indexPath) as! RocketAnotherInfoCell
            cell.setup(title1: items[indexPath.row].title1, title2: items[indexPath.row].title2)
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RocketAnotherInfoCell.self), for: indexPath) as! RocketAnotherInfoCell
            cell.setup(title1: items[indexPath.row].title1, title2: items[indexPath.row].title2)
            return cell
        case 5:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RocketAnotherInfoCell.self), for: indexPath) as! RocketAnotherInfoCell
            cell.setup(title1: items[indexPath.row].title1, title2: items[indexPath.row].title2)
            return cell
        case 6:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RocketLaunchButton.self), for: indexPath) as! RocketLaunchButton
            return cell
        default:
            <#code#>
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: RocketHeaderCell.self), for: indexPath) as! RocketHeaderCell
            header.setup(title: sections[indexPath.section].title)
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - CollectionViewDelegate

extension DataViewController: UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].count
    }

}

//// MARK: - Test Data Model
//
//struct ListItem {
//    var title1: String
//    var title2: String
//    var image: String
//}
//
//enum ListSection {
//    case one([ListItem])
//    case two([ListItem])
//    case three([ListItem])
//    case four([ListItem])
//    case five([ListItem])
//    case six([ListItem])
//    case seven([ListItem])
//    var items: [ListItem] {
//        switch self {
//        case .one(let items),
//                .two(let items),
//                .three(let items),
//                .four(let items),
//                .five(let items),
//                .six(let items),
//                .seven(let items):
//            return items
//        }
//    }
//    var count: Int {
//        return items.count
//    }
//    var title: String {
//        switch self {
//        case .one:
//            return "hui"
//        case .two:
//            return "hui"
//        case .three:
//            return "hui"
//        case .four:
//            return "hui"
//        case .five:
//            return "Первая ступень"
//        case .six:
//            return "Вторая ступень"
//        case .seven:
//            return "hui"
//        }
//    }
//}
//
//struct MockData {
//    static let shared = MockData()
//    var one: ListSection = {
//        .one([.init(title1: "", title2: "", image: "rocket")])
//    }()
//    var two: ListSection = {
//        .two([.init(title1: "FalconHeavy", title2: "", image: "")])
//    }()
//    var three: ListSection = {
//        .three([.init(title1: "Высота", title2: "229", image: ""),
//                .init(title1: "Диаметр", title2: "39", image: ""),
//                .init(title1: "Масса", title2: "3125000", image: ""),
//                .init(title1: "Нагрузка", title2: "140660", image: "")
//        ])
//    }()
//    var four: ListSection = {
//        .four([.init(title1: "Первый запуск", title2: "7 февраля", image: ""),
//               .init(title1: "Страна", title2: "USA", image: ""),
//               .init(title1: "Стоимость запуска", title2: "90$", image: "")
//        ])
//    }()
//    var five: ListSection = {
//        .five([.init(title1: "Количество двигателей", title2: "27", image: ""),
//               .init(title1: "Количество топлива", title2: "308", image: ""),
//               .init(title1: "Время сгорания", title2: "593", image: "")
//        ])
//    }()
//    var six: ListSection = {
//        .six([.init(title1: "Количество двигателей", title2: "1", image: ""),
//              .init(title1: "Количество топлива", title2: "243", image: ""),
//              .init(title1: "Время сгорания", title2: "397", image: "")
//        ])
//    }()
//    var seven: ListSection = {
//        .seven([.init(title1: "", title2: "", image: "")
//               ])
//    }()
//    var pageData: [ListSection] {
//        [one, two, three, four, five, six, seven]
//    }
//}

    //New version

enum ListItem1 {
    case image(URL)
    case title(String)
    case info(title: String, value: String)
    case button(title: String)
}

enum SectionType {
    case image
    case horizontal
    case vertical
}

struct Section {
    let sectionType: SectionType
    let title: String?
    let items: [ListItem1]
    let numberOfSection: Int
}
