//
//  LaunchPresenter.swift
//  SpaceApp
//
//  Created by Григорий Душин on 29.11.2022.
//

import Foundation
import UIKit

protocol LaunchViewProtocol: AnyObject {
    func succes(data: [LaunchData])
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
    private let launchImage = UIImage(named: LaunchImages.unknown)

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        return dateFormatter
    }()

    required init(launchLoader: LaunchLoaderProtocol, id: String) {
        self.launchLoader = launchLoader
        self.id = id
        getData()
    }

    func getData() {
        launchLoader.launchDataLoad(id: id ) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let launches):
                    self.convertingIntoNewModel(launches)
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }

    private func convertingIntoNewModel(_ old: [LaunchModelElement]) {
        var data = [LaunchData]()

        for i in 0..<old.count {
            var launchImage = UIImage(named: LaunchImages.unknown)

            if let launchingResult = old[i].success {
                launchImage = UIImage(named: (launchingResult ? LaunchImages.success : LaunchImages.unsucsess))
            }

            let launchData = LaunchData(
                name: old[i].name,
                date: dateFormatter.string(from: old[i].dateUtc),
                image: launchImage
            )
            data.append(launchData)
        }

        self.view?.succes(data: data)
    }
}
