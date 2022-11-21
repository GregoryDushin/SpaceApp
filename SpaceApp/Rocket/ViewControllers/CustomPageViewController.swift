//
//  CustomPageViewController.swift
//  SpaceApp
//
//  Created by Григорий Душин on 18.10.2022.
//

import UIKit

final class CustomPageViewController: UIPageViewController {
    private var currentViewControllerIndex = 0
    private var rockets: [RocketModelElement] = []
    private let rocketLoader = RocketLoader()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        rocketLoader.rocketDataLoad { rockets in
            DispatchQueue.main.async {
                switch rockets {
                case .success(let rockets):
                    self.rockets = rockets
                    self.configureStartingVC()
                case .failure(let error):
                    self.showAlert(error.localizedDescription)
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureStartingVC() {
        if let startingViewController = passViewControllerAt(index: currentViewControllerIndex) {
            setViewControllers([startingViewController], direction: .forward, animated: true)
        }
    }

    private func passViewControllerAt(index: Int) -> DataViewController? {
        if index >= rockets.count, rockets.isEmpty {
            return nil
        }

        guard let dataViewController =
                storyboard?.instantiateViewController(
                    withIdentifier: String(
                        describing: DataViewController.self
                    )
                ) as? DataViewController else {
            return nil
        }

        dataViewController.dataArray = rockets
        dataViewController.index = index
        dataViewController.id = rockets[index].id
        return dataViewController
    }

    // MARK: - Creating Alert Controller

    private func showAlert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        self.present(alert, animated: true)
    }

}

// MARK: - UIPageViewDataSource

extension CustomPageViewController: UIPageViewControllerDataSource {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        let dataViewController = viewController as? DataViewController
        guard var currentIndex = dataViewController?.index else {
            return nil
        }

        currentViewControllerIndex = currentIndex
        if currentIndex == 0 {
            return nil
        }

        currentIndex -= 1
        return passViewControllerAt(index: currentIndex)
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        let dataViewController = viewController as? DataViewController
        guard var currentIndex = dataViewController?.index else {
            return nil
        }

        if currentIndex == rockets.count - 1 {
            return nil
        }

        currentIndex += 1
        currentViewControllerIndex = currentIndex
        return passViewControllerAt(index: currentIndex)
    }
}
// MARK: - UIPageViewControllerDelegate

extension CustomPageViewController: UIPageViewControllerDelegate {
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        currentViewControllerIndex
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        rockets.count
    }
}
