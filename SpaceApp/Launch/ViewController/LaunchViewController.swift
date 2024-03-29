//
//  LaunchViewController.swift
//  SpaceX
//
//  Created by Григорий Душин on 09.10.2022.
//

import UIKit

final class LaunchViewController: UIViewController {
    @IBOutlet private var launchCollectionView: UICollectionView!

    private var launches: [LaunchData] = []
    private var presenter: LaunchViewPresenterProtocol

    init?(coder: NSCoder, presenter: LaunchViewPresenterProtocol) {
        self.presenter = presenter
        super.init(coder: coder)
        presenter.view = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.getData()
    }

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
            withReuseIdentifier: LaunchCell.reuseIdentifier,
            for: indexPath
        ) as? LaunchCell else { return UICollectionViewCell() }

        cell.configure(launchData: launches[indexPath.row])
        return cell
    }
}

// MARK: - LaunchViewProtocol

extension LaunchViewController: LaunchViewProtocol {

    func success(data: [LaunchData]) {
        DispatchQueue.main.async {
            self.launches = data
            self.launchCollectionView.reloadData()
        }
    }

    func failure(error: Error) {
        DispatchQueue.main.async {
            self.showAlert(error.localizedDescription)
        }
    }
}
