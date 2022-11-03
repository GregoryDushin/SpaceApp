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
            case let .verticalInfo(title, value):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RocketAnotherInfoCell", for: indexPath) as! RocketAnotherInfoCell
                cell.setup(title1: title, title2: value)
                return cell
            case .button:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RocketLaunchButton", for: indexPath) as! RocketLaunchButton
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
            guard let self = self else {
                return nil
            }
            switch section {
            case .image:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                // group
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(425)), subitems: [item])
                // section
                return NSCollectionLayoutSection(group: group)
                
            case .horizontal:
                
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                // group
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(150)), subitems: [item])
                // section
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 5
                section.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
                return section
                
            case .vertical:
                
                // item
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
                // group
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(130)), subitems: [item])
                // section
                return NSCollectionLayoutSection(group: group)
                
            case .button:
                
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
            Section(sectionType: .image, title: nil, items: [.image(url: URL(string: rocket.flickrImages[0])!, rocketName: rocket.name)]),
            Section(sectionType: .horizontal, title: nil, items:
                        [.horizontalInfo(title: "Высота", value: String(rocket.height.meters ?? 0.0)),
                         .horizontalInfo(title: "Диаметр", value: String(rocket.diameter.meters ?? 0.0)),
                         .horizontalInfo(title: "Масса", value: String(rocket.mass.kg)),
                         .horizontalInfo(title: "Полезная нагрузка", value: String(rocket.payloadWeights[0].kg))
                        ]),
            Section(sectionType: .vertical, title: nil, items:
                        [.verticalInfo(title: "Первый запуск", value: rocket.firstFlight),
                         .verticalInfo(title: "Страна", value: "США"),
                         .verticalInfo(title: "Стоимость запуска", value: String(rocket.costPerLaunch))
                        ]),
            Section(sectionType: .vertical, title: nil, items:
                        [.verticalInfo(title: "Количество двигателей", value: String(rocket.firstStage.engines)),
                         .verticalInfo(title: "Количество топлива", value: String(rocket.firstStage.fuelAmountTons)),
                         .verticalInfo(title: "Время сгорания", value: String(rocket.firstStage.burnTimeSec ?? 0))
                        ]),
            Section(sectionType: .vertical, title: nil, items:
                        [.verticalInfo(title: "Количество двигателей", value: String(rocket.secondStage.engines)),
                         .verticalInfo(title: "Количество топлива", value: String(rocket.secondStage.fuelAmountTons)),
                         .verticalInfo(title: "Время сгорания", value: String(rocket.secondStage.burnTimeSec ?? 0))
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
