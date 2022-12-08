//
//  DataViewController.swift
//  SpaceApp
//
//  Created by Григорий Душин on 18.10.2022.
//

import UIKit

final class RocketViewController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<Section, ListItem>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, ListItem>

    @IBOutlet private var collectionView: UICollectionView!

    var index: Int = 0
    var id = ""

    var rocketData: RocketModelElement?
    private var sections = [Section]()
    private lazy var dataSource = configureCollectionViewDataSource()
    private var snapshot = DataSourceSnapshot()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = createLayout()
        guard let rocket = rocketData else { return }
        sections = mapRocketToSections(rocket: rocket)
        configureHeader()
        applySnapshot()
    }

    // MARK: - Configure CollectionView DataSource

    private func configureCollectionViewDataSource() -> DataSource {
        dataSource = DataSource(
            collectionView: collectionView) { collectionView, indexPath, listItem -> UICollectionViewCell? in
                switch listItem {
                case let .image(url, rocketName):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: RocketImageCell.reuseIdentifier,
                        for: indexPath
                    ) as? RocketImageCell else { return UICollectionViewCell() }

                    cell.setup(url: url, rocketName: rocketName)
                    return cell
                case let .horizontalInfo(title, value):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: RocketHorizontalInfoCell.reuseIdentifier,
                        for: indexPath
                    ) as? RocketHorizontalInfoCell else { return UICollectionViewCell() }

                    cell.setup(title: title, value: value)
                    return cell
                case let .verticalInfo(title, value, _):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: RocketVerticalInfoCell.reuseIdentifier,
                        for: indexPath
                    ) as? RocketVerticalInfoCell else { return UICollectionViewCell() }

                    cell.setup(title: title, value: value)
                    return cell
                case .button:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: RocketLaunchButtonCell.reuseIdentifier,
                        for: indexPath
                    ) as? RocketLaunchButtonCell else { return UICollectionViewCell() }

                    return cell
                }
            }

        return dataSource
    }

    private func applySnapshot() {
        snapshot = DataSourceSnapshot()
        for section in sections {
            snapshot.appendSections([section])
            snapshot.appendItems(section.items, toSection: section)
        }

        dataSource.apply(snapshot)
    }

    private func configureHeader() {
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderCell.reuseIdentifier,
                for: indexPath
            )
                    as? HeaderCell else {return UICollectionReusableView()
            }

            header.setup(title: self.sections[indexPath.section].title ?? "")
            return header
        }
    }

    // MARK: - Creating sections using CompositionalLayout

    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
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

    private func mapRocketToSections(rocket: RocketModelElement) -> [Section] {
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

        return sections
    }

    // MARK: - Data transfer between View Controllers

    @IBSegueAction
    func transferLaunchInfo(_ coder: NSCoder) -> LaunchViewController? {
        let presenter = LaunchPresenter(launchLoader: LaunchLoader(), id: id)

        return LaunchViewController(coder: coder, presenter: presenter)
    }

    @IBSegueAction
    func transferSettingsInfo(_ coder: NSCoder) -> SettingsViewController? {
        let presenter = SettingsPresenter { [weak self] in
            guard let self = self, let rocket = self.rocketData else { return }
            self.sections = self.mapRocketToSections(rocket: rocket)
            self.applySnapshot()
        }
        return SettingsViewController(coder: coder, presenter: presenter)
    }
}
