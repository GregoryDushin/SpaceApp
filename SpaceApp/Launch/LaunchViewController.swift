//
//  LaunchViewController.swift
//  SpaceX
//
//  Created by Григорий Душин on 09.10.2022.
//

import UIKit

final class LaunchViewController: UIViewController {
    @IBOutlet private var launchCollectionView: UICollectionView!
    private var launches: [LaunchModelElement] = []
    var newId = ""
    private let launchLoader = LaunchLoader()

    override func viewDidLoad() {
        super.viewDidLoad()
        launchLoader(id: newId)
    }

    private func launchLoader(id: String) {
        launchLoader.launchDataLoad(id: id) { launches in
            DispatchQueue.main.async {
                switch launches {
                case .success(let launches):
                    self.launches = launches
                    self.launchCollectionView.reloadData()

                case .failure(let error):
                    self.showAlert(error.localizedDescription)
                }
            }
        }
    }

    private func showAlert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        self.present(alert, animated: true)
    }
}

// MARK: - CollectionViewDelegateFlowLayout

extension LaunchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let widthCell = UIScreen.main.bounds.width - 40
        return CGSize(width: widthCell, height: 100)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        launches.count
    }
}

// MARK: - Collection View Data Source
extension LaunchViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath:
                        IndexPath
    ) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CollectionViewCell",
            for: indexPath
        ) as? CollectionViewCell else {return UICollectionViewCell()}
        let dates = launches[indexPath.row].dateUtc.dateFormatter()
        cell.configure(rocket: launches[indexPath.row], dates: dates)
        return cell
    }
}

private extension Date {

    func dateFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        return dateFormatter.string(from: self)
    }
}
