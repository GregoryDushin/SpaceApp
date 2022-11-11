//
//  DataViewController.swift
//  SpaceApp
//
//  Created by Григорий Душин on 18.10.2022.
//

import UIKit

final class DataViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView!
    var displayText: String?
    var index: Int = 0
    var id = ""
    var dataArray: [RocketModelElement] = []
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ListItem>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, ListItem>
    private var sections = [Section]()
    var dataSource: DataSource!
    private var snapshot = DataSourceSnapshot()

    // MARK: - Configure CollectionView DataSource

    private func configureCollectionViewDataSource() {
        dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, listItem -> UICollectionViewCell? in
            self.sections[indexPath.section].items[indexPath.row]
            switch listItem {
            case let .image(url, rocketName):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "RocketImageCell",
                    for: indexPath) as! RocketImageCell
                cell.setup(url: url, rocketName: rocketName)
                return cell
            case let .horizontalInfo(title, value):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "RocketDescriptionCell",
                    for: indexPath) as! RocketHorizontalInfoCell
                cell.setup(title: title, value: value)
                return cell
            case let .verticalInfo(title, value, _):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "RocketAnotherInfoCell",
                    for: indexPath) as! RocketVerticalInfoCell
                cell.setup(title: title, value: value)
                return cell
            case .button:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "RocketLaunchButton",
                    for: indexPath) as! RocketLaunchButton
                return cell
            }
        })
    }

    // MARK: - Configure Snapshot

    private func applySnapshot() {
        snapshot = DataSourceSnapshot()
        for section in sections {
            snapshot.appendSections([section])
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot)
    }

    // MARK: - Configure Header

    func configureHeader() {
        dataSource?.supplementaryViewProvider = {(
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                header.setup(title: self.sections[indexPath.section].title ?? "")
                return header
            }
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = createLayout()
        sections =  mapRocketToSections(rocket: dataArray[index])
        configureCollectionViewDataSource()
        configureHeader()
        applySnapshot()
        collectionView.reloadData()

    }

    // MARK: - Creating sections using CompositionalLayout

    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout {[weak self] sectionIndex, _ in
            let section = self!.dataSource.snapshot().sectionIdentifiers[sectionIndex].sectionType
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
                // HEADER TROUBLE
                let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize,elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [sectionHeader]
                return section
            case .button:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), subitems: [item])
                return NSCollectionLayoutSection(group: group)

            }
        }
    }

    // MARK: - Implementing data from URL into items

    private func mapRocketToSections(rocket: RocketModelElement) -> [Section] {
        [Section(sectionType: .image,
                    title: nil,
                    items: [.image(url: URL(string: rocket.flickrImages[0])!, rocketName: rocket.name)]),
            Section(sectionType: .horizontal,
                    title: nil,
                    items:
                        [.horizontalInfo(title: "Высота, ft",
                                         value: String(rocket.height.meters ?? 0.0)),
                         .horizontalInfo(title: "Диаметр, ft",
                                         value: String(rocket.diameter.meters ?? 0.0)),
                         .horizontalInfo(title: "Масса, lb",
                                         value: String(rocket.mass.kg)),
                         .horizontalInfo(title: "Нагрузка, lb",
                                         value: String(rocket.payloadWeights[0].kg))]),
            Section(sectionType: .vertical,
                    title: nil,
                    items:
                        [.verticalInfo(title: "Первый запуск",
                                       value: rocket.firstFlight,
                                       id: UUID()),
                         .verticalInfo(title: "Страна",
                                       value: "США",
                                       id: UUID()),
                         .verticalInfo(title: "Стоимость запуска",
                                       value: "$" + String((rocket.costPerLaunch)/1000000) + " млн",
                                       id: UUID())]),
            Section(sectionType: .vertical,
                    title: "Первая ступень",
                    items:
                        [.verticalInfo(title: "Количество двигателей",
                                         value: String(rocket.firstStage.engines),
                                         id: UUID()),
                         .verticalInfo(title: "Количество топлива",
                                       value: (NSString(format: "%.0f", rocket.firstStage.fuelAmountTons) as String) + " тонн", id: UUID()),
                         .verticalInfo(title: "Время сгорания",
                                       value: String(rocket.firstStage.burnTimeSec ?? 0) + " сек", id: UUID())]),
            Section(sectionType: .vertical, title: "Вторая ступень", items:
                        [.verticalInfo(title: "Количество двигателей",
                                       value: String(rocket.secondStage.engines),
                                       id: UUID()),
                         .verticalInfo(title: "Количество топлива",
                                       value: (NSString(format: "%.0f", rocket.secondStage.fuelAmountTons) as String) + " тонн", id: UUID()),
                         .verticalInfo(title: "Время сгорания",
                                       value: String(rocket.secondStage.burnTimeSec ?? 0) + " сек",
                                       id: UUID())
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
