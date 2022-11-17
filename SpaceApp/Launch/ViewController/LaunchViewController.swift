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
    private var newId: String
    private let launchLoader = LaunchLoader()

    init?(coder: NSCoder, newId: String) {
        self.newId = newId
        super.init(coder: coder)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        launchLoader(id: newId)
    }

    // MARK: - LaunchLoader

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

    // MARK: - Creating Alert Controller

    private func showAlert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        self.present(alert, animated: true)
    }
}

// MARK: - CollectionViewDelegateFlowLayout

extension LaunchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
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
            withReuseIdentifier: CollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? CollectionViewCell else {return UICollectionViewCell() }

        var isSuccessImg = UIImage(named: LaunchImages.unknown)
        if let launchingResult = launches[indexPath.row].success {
            isSuccessImg = UIImage(named: (launchingResult ? LaunchImages.success : LaunchImages.unsucsess))
        }
        cell.configure(
            name: launches[indexPath.row].name,
            date: dateFormatter.string(
                from:
                    launches[indexPath.row].dateUtc
            ),
            image: isSuccessImg
        )
        return cell
    }
}
