//
//  LaunchPresenter.swift
//  SpaceApp
//
//  Created by Григорий Душин on 29.11.2022.
//

import Foundation
import UIKit

// MARK: протокол реализует VC, ссылку держит презентер

protocol LaunchViewProtocol: AnyObject {
    func succes(data: [LaunchData])
    func failure(error: Error)
}

// MARK: протокол реализует презентер, ссылку держит VC

protocol LaunchViewPresenterProtocol: AnyObject {
    func getData()
    var view: LaunchViewProtocol? { get set }
}

class LaunchPresenter: LaunchViewPresenterProtocol {
    weak var view: LaunchViewProtocol?
    var id: String
    let launchLoader: LaunchLoaderProtocol
    var launchImage = UIImage(named: LaunchImages.unknown)

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

    // MARK: получаем данные

    func getData() {
        launchLoader.launchDataLoad(id: id ) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let launches):
                    self.convertingIntoNewModel(old: launches)
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }

    // MARK: конвертация данных в новую модель

    func convertingIntoNewModel(old: [LaunchModelElement]) {
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
