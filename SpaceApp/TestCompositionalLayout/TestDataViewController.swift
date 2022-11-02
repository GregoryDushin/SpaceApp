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
            switch listItem {
            case .image:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RocketImageCell", for: indexPath) as! RocketImageCell
                return cell
            case .title:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RocketNameCell", for: indexPath) as! RocketNameCell
                
                return cell
            case .horizontalInfo:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RocketDescriptionCell", for: indexPath) as! RocketDescriptionCell
                
                return cell
            case .verticalInfo:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RocketAnotherInfoCell", for: indexPath) as! RocketAnotherInfoCell
                cell.setup(title1: "hz", title2: "hz")
                return cell
            case .button:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RocketLaunchButton", for: indexPath) as! RocketLaunchButton
                return cell
            }
        })
    }
    
    private func applySnapshot() {
        snapshot = DataSourseSnapshot()
     //   snapshot.appendSections([Section])
      //  snapshot.appendItems([ListItem])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView.collectionViewLayout = createLayout()
        collectionView.reloadData()
        sections =  mapRocketToSections(rocket: dataArray[index])
    }
    // MARK: - Creating sections using CompositionalLayout
    
    //    private func createLayout() -> UICollectionViewCompositionalLayout {
    //        UICollectionViewCompositionalLayout {[weak self] sectionIndex, _ in
    //            guard let self = self else {
    //                return nil
    //            }
    //            let section = self.sections[sectionIndex]
    //            switch section {
    //            case .one:
    //                // item
    //                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
    //                // group
    //                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(425), heightDimension: .absolute(425)), subitems: [item])
    //                // section
    //                return NSCollectionLayoutSection(group: group)
    //            case .two:
    //                // item
    //                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
    //                // group
    //                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), subitems: [item])
    //                // section
    //                return NSCollectionLayoutSection(group: group)
    //            case .three:
    //                // item
    //                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
    //                // group
    //                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(150)), subitems: [item])
    //                // section
    //                let section = NSCollectionLayoutSection(group: group)
    //                section.orthogonalScrollingBehavior = .continuous
    //                section.interGroupSpacing = 5
    //                section.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
    //                return section
    //            case .four:
    //                // item
    //                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
    //                // group
    //                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(130)), subitems: [item])
    //                // section
    //                return NSCollectionLayoutSection(group: group)
    //            case .five:
    //                // item
    //                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
    //                // group
    //                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(130)), subitems: [item])
    //                // section
    //                let section = NSCollectionLayoutSection(group: group)
    //                section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
    //                return section
    //            case .six:
    //                // item
    //                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
    //                // group
    //                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(130)), subitems: [item])
    //                // section
    //                let section = NSCollectionLayoutSection(group: group)
    //                section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
    //                return section
    //            case .seven:
    //                // item
    //                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
    //                // group
    //                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), subitems: [item])
    //                // section
    //                return NSCollectionLayoutSection(group: group)
    //
    //            }
    //        }
    //    }
    
    private func mapRocketToSections(rocket: RocketModelElement) -> [Section] {
        [
            Section(sectionType: .image, title: nil, items: [.image(URL(fileURLWithPath: rocket.flickrImages[0])), .title(rocket.name)]),
            
            Section(sectionType: .horizontal, title: nil, items:
                        [.horizontalInfo(title: "Высота", value: String(rocket.height.meters ?? 0.0)),
                         .horizontalInfo(title: "Диаметр", value: String(rocket.diameter.meters ?? 0.0)),
                         .horizontalInfo(title: "Масса", value: String(rocket.mass.kg)),
                         .horizontalInfo(title: "Масса", value: String(rocket.payloadWeights[0].kg))
                        ]),
            Section(sectionType: .vertical, title: nil, items:
                        [.verticalInfo(title: "Первый запуск", value: rocket.firstFlight),
                         .verticalInfo(title: "Страна", value: "США"),
                         .verticalInfo(title: "Стоимость запуска", value: String(rocket.costPerLaunch))
                        ]),
            Section(sectionType: .vertical, title: nil, items:
                        [.verticalInfo(title: "Количество двигателей", value: String(rocket.firstStage.engines)),
                         .verticalInfo(title: "Количество топлива", value: String(rocket.firstStage.fuelAmountTons)),
                         .verticalInfo(title: "Время сгорания", value: String(rocket.firstStage.burnTimeSEC ?? 0))
                        ]),
            Section(sectionType: .vertical, title: nil, items:
                        [.verticalInfo(title: "Количество двигателей", value: String(rocket.secondStage.engines)),
                         .verticalInfo(title: "Количество топлива", value: String(rocket.secondStage.fuelAmountTons)),
                         .verticalInfo(title: "Время сгорания", value: String(rocket.secondStage.burnTimeSEC ?? 0))
                        ])
            
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
