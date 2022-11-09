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
    var sections = [Section]()
    typealias DataSourse = UICollectionViewDiffableDataSource<Section, ListItem>
    typealias DataSourseSnapshot = NSDiffableDataSourceSnapshot<Section, ListItem>
    private var dataSourse: DataSourse!
    private var snapshot = DataSourseSnapshot()
    private func configureCollectionViewDataSource() {
        dataSourse = DataSourse(collectionView: collectionView, cellProvider: { collectionView, indexPath, listItem -> UICollectionViewCell? in
            self.sections[indexPath.section].items[indexPath.row]
            switch listItem {
            case let .image(url, rocketName):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RocketImageCell", for: indexPath) as! RocketImageCell
                cell.setup(url: url, rocketName: rocketName)
                return cell
            case let .horizontalInfo(title, value):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RocketDescriptionCell", for: indexPath) as! RocketDescriptionCell
                cell.setup(title1: title, title2: value)
                return cell
            case let .verticalInfo(title, value, _):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RocketAnotherInfoCell", for: indexPath) as! RocketAnotherInfoCell
                cell.setup(title1: title, title2: value)
                return cell
            case .button:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RocketLaunchButton", for: indexPath) as! RocketLaunchButton
                cell.setup()
                return cell
            }
        })
    }

    private func applySnapshot() {
        snapshot = DataSourseSnapshot()
        for section in sections {
            snapshot.appendSections([section])
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSourse.apply(snapshot)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = createLayout()
        sections =  mapRocketToSections(rocket: dataArray[index])
        configureCollectionViewDataSource()
        applySnapshot()
        collectionView.reloadData()
    }
    // MARK: - Creating sections using CompositionalLayout

    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout {[weak self] sectionIndex, _ in
            let section = self!.dataSourse.snapshot().sectionIdentifiers[sectionIndex].sectionType
            guard self != nil else {
                return nil
            }
            switch section {
            case .image:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.6)), subitems: [item])
                return NSCollectionLayoutSection(group: group)
            case .horizontal:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(150)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 5
                section.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
                return section
            case .vertical:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(130)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
//hz                section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                return section
            case .button:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), subitems: [item])
                return NSCollectionLayoutSection(group: group)

            }
        }
    }

    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }

    private func mapRocketToSections(rocket: RocketModelElement) -> [Section] {
        [
            Section(sectionType: .image, title: nil, items: [.image(url: URL(string: rocket.flickrImages[0])!, rocketName: rocket.name)]),
            Section(sectionType: .horizontal, title: nil, items:
                        [.horizontalInfo(title: "Высота", value: String(rocket.height.meters ?? 0.0)),
                         .horizontalInfo(title: "Диаметр", value: String(rocket.diameter.meters ?? 0.0)),
                         .horizontalInfo(title: "Масса", value: String(rocket.mass.kg)),
                         .horizontalInfo(title: "Нагрузка", value: String(rocket.payloadWeights[0].kg))
                        ]),
            Section(sectionType: .vertical, title: nil, items:
                        [.verticalInfo(title: "Первый запуск", value: rocket.firstFlight, id: UUID()),
                         .verticalInfo(title: "Страна", value: "США", id: UUID()),
                         .verticalInfo(title: "Стоимость запуска", value: String(rocket.costPerLaunch), id: UUID())
                        ]),
            Section(sectionType: .vertical, title: "Первая ступень", items:
                        [.verticalInfo(title: "Количество двигателей", value: String(rocket.firstStage.engines), id: UUID()),
                         .verticalInfo(title: "Количество топлива", value: String(rocket.firstStage.fuelAmountTons), id: UUID()),
                         .verticalInfo(title: "Время сгорания", value: String(rocket.firstStage.burnTimeSec ?? 0), id: UUID())
                        ]),
            Section(sectionType: .vertical, title: "Вторая ступень", items:
                        [.verticalInfo(title: "Количество двигателей", value: String(rocket.secondStage.engines), id: UUID()),
                         .verticalInfo(title: "Количество топлива", value: String(rocket.secondStage.fuelAmountTons), id: UUID()),
                         .verticalInfo(title: "Время сгорания", value: String(rocket.secondStage.burnTimeSec ?? 0), id: UUID())
                        ]),
            Section(sectionType: .button, title: nil, items: [.button])
        ]
    }

    // MARK: - Data transfer to the launch VC

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showLaunch" else { return }
        guard let destination = segue.destination as? LaunchViewController else { return }
        destination.newId = id
        destination.title = displayText
    }
}
extension DataViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            header.setup(title: sections[indexPath.section].title ?? "hueta")
            return header
        default:
            return UICollectionReusableView()
        }
    }
}
