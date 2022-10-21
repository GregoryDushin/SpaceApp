//
//  LaunchViewController.swift
//  SpaceX
//
//  Created by Григорий Душин on 09.10.2022.
//

import UIKit

class LaunchViewController: UIViewController {
    @IBOutlet var launchCollectionView: UICollectionView!
    private var launches: [LaunchModelElement] = []
    private var id = "5e9d0d95eda69955f709d1eb"   // just for testing (Falcon 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Falcon 1"
        launchLoader(id: id)
    }
    
    private func launchLoader(id: String) {
        LaunchLoader().launchDataLoad(id: id) { launches in
            DispatchQueue.main.async {
                self.launches = launches
                self.launchCollectionView.reloadData()
            }
        }
    }
}

// MARK: - CollectionViewDelegateFlowLayout

extension LaunchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, sizeForItemAt indexPath:
                        IndexPath) -> CGSize {
        let widthCell = UIScreen.main.bounds.width - 40
        return CGSize(width: widthCell, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return launches.count
    }
}

// MARK: - Collection View Data Source
extension LaunchViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:
                        IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                        String(describing: CollectionViewCell.self), for:
                                                        indexPath) as! CollectionViewCell

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
