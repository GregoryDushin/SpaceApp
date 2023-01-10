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

    var presenter: RocketViewPresenterProtocol!
    var index: Int = 0
    var id: String = ""

    private lazy var dataSource = configureCollectionViewDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.getData()
        collectionView.collectionViewLayout = createLayout()
        configureHeader()
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

    private func configureHeader() {
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderCell.reuseIdentifier,
                for: indexPath
            ) as? HeaderCell else { return UICollectionReusableView()
            }
            header.setup(title: self.dataSource.snapshot().sectionIdentifiers[indexPath.section].title ?? "")
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

    // MARK: - Data transfer between View Controllers

    @IBSegueAction
    func transferLaunchInfo(_ coder: NSCoder) -> LaunchViewController? {
        let presenter = LaunchPresenter(launchLoader: LaunchLoader(), id: id)

        return LaunchViewController(coder: coder, presenter: presenter)
    }

    @IBSegueAction
    func transferSettingsInfo(_ coder: NSCoder) -> SettingsViewController? {
        let presenter = SettingsPresenter { [weak self] in
            guard let self = self else { return }
            self.presenter.getData()
        }

        return SettingsViewController(coder: coder, presenter: presenter)
    }
}

extension RocketViewController: RocketViewProtocol {
    func present(data: [Section]) {
        var snapshot = DataSourceSnapshot()
        snapshot = DataSourceSnapshot()
        for section in data {
            snapshot.appendSections([section])
            snapshot.appendItems(section.items, toSection: section)
        }

        dataSource.apply(snapshot)
    }
}
