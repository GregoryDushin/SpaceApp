//
//  LaunchPresenter.swift
//  SpaceApp
//
//  Created by Григорий Душин on 29.11.2022.
//

import Foundation
import UIKit

protocol LaunchViewProtocol: AnyObject {
    func success(data: [LaunchData])
    func failure(error: Error)
}

protocol LaunchViewPresenterProtocol: AnyObject {
    func getData()
    var view: LaunchViewProtocol? { get set }
}

final class LaunchPresenter: LaunchViewPresenterProtocol {
    weak var view: LaunchViewProtocol?
    private let id: String
    private let launchLoader: LaunchLoaderProtocol

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        return dateFormatter
    }()

    required init(launchLoader: LaunchLoaderProtocol, id: String) {
        self.launchLoader = launchLoader
        self.id = id
    }

    func getData() {
        launchLoader.launchDataLoad(id: id ) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let launches):
                    self.transferDataIntoLaunchVC(launches)
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }

    private func transferDataIntoLaunchVC(_ launchModel: [LaunchModelElement]) {
        var data = [LaunchData]()

        launchModel.map {
            let launchImage: UIImage

            if let launchingResult = $0.success {
                launchImage = UIImage.named( (launchingResult ? LaunchImages.success : LaunchImages.unsucsess))
            } else {
                launchImage = UIImage.named(LaunchImages.unknown)
            }

            let launchData = LaunchData(
                name: $0.name,
                date: dateFormatter.string(from: $0.dateUtc),
                image: launchImage
            )
            data.append(launchData)
        }

        self.view?.success(data: data)
    }

}
