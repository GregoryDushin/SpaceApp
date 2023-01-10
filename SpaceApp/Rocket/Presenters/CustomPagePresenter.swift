//
//  CustomPagePresenter.swift
//  SpaceApp
//
//  Created by Григорий Душин on 10.12.2022.
//

import Foundation

protocol CustomPageViewProtocol: AnyObject {
    func success(data: [RocketModelElement])
    func failure(error: Error)
}

protocol CustomPageViewPresenterProtocol: AnyObject {
    func getData()
    var view: CustomPageViewProtocol? { get set }
}

final class CustomPagePresenter: CustomPageViewPresenterProtocol {
    weak var view: CustomPageViewProtocol?
    private let rocketLoader: RocketLoaderProtocol

     init(rocketLoader: RocketLoaderProtocol) {
        self.rocketLoader = rocketLoader
    }

    func getData() {
        rocketLoader.rocketDataLoad { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let rockets):
                    self.view?.success(data: rockets)
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
}
