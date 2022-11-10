//
//  ViewController.swift
//  SpaceX
//
//  Created by Григорий Душин on 06.10.2022.
//

import UIKit

final class RocketViewController: UIViewController {
    @IBOutlet private var contentView: UIView!
    private var currentViewControllerIndex = 0
    private var rockets: [RocketModelElement] = []
    private let rocketLoader = RocketLoader()

    override func viewDidLoad() {
        super.viewDidLoad()

        rocketLoader.rocketDataLoad { rockets in
            DispatchQueue.main.async {
                switch rockets {
                case .success(let rockets):
                    self.rockets = rockets
                    self.configurePageViewController()
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

   private func configurePageViewController() {
        guard let pageViewController =
                storyboard?.instantiateViewController(withIdentifier: String(describing: CustomPageViewController.self))
                as? CustomPageViewController else {
            return
        }
        pageViewController.delegate = self
        pageViewController.dataSource = self
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        pageViewController.view.backgroundColor = UIColor.black
        contentView.addSubview(pageViewController.view)

        guard let startingViewController = passViewControllerAt(index: currentViewControllerIndex) else { return }
        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
    }

   private func passViewControllerAt(index: Int) -> DataViewController? {
        if index >= rockets.count, rockets.count == 0 {return nil}
        guard let dataViewController =
                storyboard?.instantiateViewController(withIdentifier: String(describing: DataViewController.self)) as? DataViewController else {return nil}
        dataViewController.dataArray = rockets
        dataViewController.index = index
        dataViewController.displayText = rockets[index].name
        dataViewController.id = rockets[index].id
        return dataViewController
    }

    private func showAlert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        self.present(alert, animated: true)
    }
}

// MARK: - UIPageViewDataSource

extension RocketViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
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

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
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

extension RocketViewController: UIPageViewControllerDelegate {
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentViewControllerIndex
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return rockets.count
    }

}
