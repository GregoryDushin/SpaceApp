//
//  DataViewController.swift
//  SpaceApp
//
//  Created by Григорий Душин on 18.10.2022.
//

import UIKit

final class DataViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView!
    var index: Int = 0
    var id = ""
    var dataArray: [RocketModelElement] = []
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ListItem>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, ListItem>
    private var sections = [Section]()
    private lazy var dataSource = configureCollectionViewDataSource()
    private var snapshot = DataSourceSnapshot()

// MARK: - Configure CollectionView DataSource

    private func configureCollectionViewDataSource() -> DataSource {
        dataSource = DataSource(
            collectionView: { collectionView }(),
            cellProvider: { collectionView, indexPath, listItem -> UICollectionViewCell? in
                _ = self.sections[indexPath.section].items[indexPath.row]
                switch listItem {
                case let .image(url, rocketName):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: RocketImageCell.reuseIdentifier,
                        for: indexPath
                    ) as? RocketImageCell else {return UICollectionViewCell()}
                    if let url = url {
                        cell.setup(url: url, rocketName: rocketName)
                    }
                    return cell
                case let .horizontalInfo(title, value):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: RocketHorizontalInfoCell.reuseIdentifier,
                        for: indexPath
                    ) as? RocketHorizontalInfoCell else {return UICollectionViewCell()}
                    cell.setup(title: title, value: value)
                    return cell
                case let .verticalInfo(title, value, _):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: RocketVerticalInfoCell.reuseIdentifier,
                        for: indexPath
                    ) as? RocketVerticalInfoCell else {return UICollectionViewCell()}
                    cell.setup(title: title, value: value)
                    return cell
                case .button:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: RocketLaunchButtonCell.reuseIdentifier,
                        for: indexPath
                    ) as? RocketLaunchButtonCell else {return UICollectionViewCell()}
                    return cell
                }
            }
        )
        return dataSource
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
        dataSource.supplementaryViewProvider = {collectionView, kind, indexPath -> UICollectionReusableView? in
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: HeaderCell.reuseIdentifier, for: indexPath
            ) as? HeaderCell else {return UICollectionReusableView()}
            header.setup(title: self.sections[indexPath.section].title ?? "")
            return header
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = createLayout()
        sections = mapRocketToSections(rocket: dataArray[index])
        configureHeader()
        applySnapshot()
        collectionView.reloadData()
    }

// MARK: - Creating sections using CompositionalLayout

    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout {[weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex].sectionType
            switch section {
            case .image:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.6)), subitems: [item]
                )
                return NSCollectionLayoutSection(group: group)
            case .horizontal:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(150)), subitems: [item]
                )
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 5
                section.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
                return section
            case .vertical:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(130)), subitems: [item]
                )
                let section = NSCollectionLayoutSection(group: group)
                let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerFooterSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top
                )
                section.boundarySupplementaryItems = [sectionHeader]
                return section
            case .button:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), subitems: [item]
                )
                return NSCollectionLayoutSection(group: group)
            }
        }
    }

// MARK: - Implementing data from URL into items

    private func mapRocketToSections(rocket: RocketModelElement) -> [Section] {
        [
            Section(
                sectionType: .image,
                title: nil,
                items: [.image(url: URL(string: rocket.flickrImages[0]), rocketName: rocket.name)]
            ),
            Section(
                sectionType: .horizontal,
                title: nil,
                items:
                    [
                        .horizontalInfo(
                            title: "Высота, ft",
                            value: String(rocket.height.meters ?? 0.0)
                        ),
                        .horizontalInfo(
                            title: "Диаметр, ft",
                            value: String(rocket.diameter.meters ?? 0.0)
                        ),
                        .horizontalInfo(
                            title: "Масса, lb",
                            value: String(rocket.mass.kg)
                        ),
                        .horizontalInfo(
                            title: "Нагрузка, lb",
                            value: String(rocket.payloadWeights[0].kg)
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
                            value: rocket.firstFlight,
                            id: UUID()
                        ),
                        .verticalInfo(
                            title: "Страна",
                            value: "США",
                            id: UUID()
                        ),
                        .verticalInfo(
                            title: "Стоимость запуска",
                            value: "$" + String((rocket.costPerLaunch) / 1_000_000) + " млн",
                            id: UUID()
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
                            value: String(rocket.firstStage.engines),
                            id: UUID()
                        ),
                        .verticalInfo(
                            title: "Количество топлива",
                            value: (NSString(format: "%.0f", rocket.firstStage.fuelAmountTons) as String) + " тонн",
                            id: UUID()
                        ),
                        .verticalInfo(
                            title: "Время сгорания",
                            value: String(rocket.firstStage.burnTimeSec ?? 0) + " сек",
                            id: UUID()
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
                            value: String(rocket.secondStage.engines),
                            id: UUID()
                        ),
                        .verticalInfo(
                            title: "Количество топлива",
                            value: (NSString(format: "%.0f", rocket.secondStage.fuelAmountTons) as String) + " тонн",
                            id: UUID()
                        ),
                        .verticalInfo(
                            title: "Время сгорания",
                            value: String(rocket.secondStage.burnTimeSec ?? 0) + " сек",
                            id: UUID()
                        )
                    ]
            ),
            Section(sectionType: .button, title: nil, items: [.button])
        ]
    }

// MARK: - Data transfer to the Launch VC

    @IBSegueAction
    func transferLaunchInfo(_ coder: NSCoder) -> LaunchViewController? {
        LaunchViewController(coder: coder, newId: self.id)
    }
}
