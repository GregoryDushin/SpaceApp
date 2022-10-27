//
//  LaunchViewController.swift
//  SpaceX
//
//  Created by Григорий Душин on 09.10.2022.
//

import UIKit

final class LaunchViewController: UIViewController {
    @IBOutlet var launchCollectionView: UICollectionView!
    private var launches: [LaunchModelElement] = []
    var newId = ""
    var newTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        title = newTitle
        launchLoader(id: newId)
    }

    private func launchLoader(id: String) {
        LaunchLoader().launchDataLoad(id: id) { launches in
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

    func showAlert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true)
    }
}

// MARK: - CollectionViewDelegateFlowLayout

extension LaunchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthCell = UIScreen.main.bounds.width - 40
        return CGSize(width: widthCell, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return launches.count
    }
}

// MARK: - Collection View Data Source
extension LaunchViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self), for: indexPath) as! CollectionViewCell

        func dateFormatter (utcDate: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YY"
            return dateFormatter.string(from: utcDate)
        }
        let dates = dateFormatter(utcDate: launches[indexPath.row].dateUtc)
        cell.configure(rocket: launches[indexPath.row], dates: dates)
        return cell
    }
}
