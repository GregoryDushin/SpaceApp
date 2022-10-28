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
    var data = MockData()
    private let sections = MockData.shared.pageData

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = createLayout()
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout {[weak self] sectionIndex, _ in
            guard let self = self else {
                return nil
            }
            let section = self.sections[sectionIndex]
            switch section {
            case .one:
                // item
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                // group
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(425), heightDimension: .absolute(425)), subitems: [item])
                // section
                return NSCollectionLayoutSection(group: group)
            case .two:
                // item
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                // group
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), subitems: [item])
                // section
                return NSCollectionLayoutSection(group: group)
            case .three:
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
            case .four:
                // item
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
                // group
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(130)), subitems: [item])
                // section
                return NSCollectionLayoutSection(group: group)
            case .five:
                // item
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
                // group
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(130)), subitems: [item])
                // section
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                return section
            case .six:
                // item
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
                // group
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(130)), subitems: [item])
                // section
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]

                return section
            case .seven:
                // item
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                // group
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), subitems: [item])
                // section
                return NSCollectionLayoutSection(group: group)

            }
        }
    }
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showLaunch" else { return }
        guard let destination = segue.destination as? LaunchViewController else { return }
        destination.newId = id
        destination.title = displayText
    }
}
extension DataViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .one(let items):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RocketImageCell", for: indexPath) as! RocketImageCell
            cell.setup(title: items[0].image)
            return cell
        case .two:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RocketNameCell", for: indexPath) as! RocketNameCell
            cell.setup(title: dataArray[index].name)
            return cell
        case .three(let items):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RocketDescriptionCell", for: indexPath) as! RocketDescriptionCell
            cell.setup(title1: items[indexPath.row].title1, title2: items[indexPath.row].title2)
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 12
            return cell
        case .four(let items):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RocketAnotherInfoCell", for: indexPath) as! RocketAnotherInfoCell
            cell.setup(title1: items[indexPath.row].title1, title2: items[indexPath.row].title2)
            return cell
        case .five(let items):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RocketAnotherInfoCell", for: indexPath) as! RocketAnotherInfoCell
            cell.setup(title1: items[indexPath.row].title1, title2: items[indexPath.row].title2)
            return cell
        case .six(let items):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RocketAnotherInfoCell", for: indexPath) as! RocketAnotherInfoCell
            cell.setup(title1: items[indexPath.row].title1, title2: items[indexPath.row].title2)
            return cell
        case .seven:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RocketLaunchButton", for: indexPath) as! RocketLaunchButton
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RocketHeaderCell", for: indexPath) as! RocketHeaderCell
            header.setup(title: sections[indexPath.section].title)
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

struct ListItem {
    var title1: String
    var title2: String
    var image: String
}

enum ListSection {
    case one([ListItem])
    case two([ListItem])
    case three([ListItem])
    case four([ListItem])
    case five([ListItem])
    case six([ListItem])
    case seven([ListItem])

    var items: [ListItem] {
        switch self {
        case .one(let items),
                .two(let items),
                .three(let items),
                .four(let items),
                .five(let items),
                .six(let items),
                .seven(let items):
            return items
        }
    }

    var count: Int {
        return items.count
    }

    var title: String {
        switch self {
        case .one:
            return "hui"
        case .two:
            return "hui"
        case .three:
            return "hui"
        case .four:
            return "hui"
        case .five:
            return "Первая ступень"
        case .six:
            return "Вторая ступень"
        case .seven:
            return "hui"
        }
    }
}

struct MockData {
    static let shared = MockData()

     var one: ListSection = {
        .one([.init(title1: "", title2: "", image: "rocket")])
    }()
     var two: ListSection = {
        .two([.init(title1: "FalconHeavy", title2: "", image: "")])
    }()
     var three: ListSection = {
        .three([.init(title1: "Высота", title2: "229", image: ""),
                     .init(title1: "Диаметр", title2: "39", image: ""),
                     .init(title1: "Масса", title2: "3125000", image: ""),
                     .init(title1: "Нагрузка", title2: "140660", image: "")
        ])
    }()
     var four: ListSection = {
        .four([.init(title1: "Первый запуск", title2: "7 февраля", image: ""),
                     .init(title1: "Страна", title2: "USA", image: ""),
                     .init(title1: "Стоимость запуска", title2: "90$", image: "")
        ])
    }()
     var five: ListSection = {
        .five([.init(title1: "Количество двигателей", title2: "27", image: ""),
               .init(title1: "Количество топлива", title2: "308", image: ""),
               .init(title1: "Время сгорания", title2: "593", image: "")
  ])
    }()
     var six: ListSection = {
        .six([.init(title1: "Количество двигателей", title2: "1", image: ""),
              .init(title1: "Количество топлива", title2: "243", image: ""),
              .init(title1: "Время сгорания", title2: "397", image: "")
 ])
    }()
    var seven: ListSection = {
        .seven([.init(title1: "", title2: "", image: "")
        ])
    }()
    var pageData: [ListSection] {
        [one, two, three, four, five, six, seven]
    }
}
