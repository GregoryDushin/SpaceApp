//
//  ViewController.swift
//  SpaceX
//
//  Created by Григорий Душин on 06.10.2022.
//

import UIKit

class RocketViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    var dataSource = ["Rocket_1", "Rocket_2", "Rocket_3", "Rocket_4"]
    var currentViewControllerIndex = 0
    // MARK: Arrays for recieving data from parsing loaders
    var rockets: [RocketModelElement] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: Recieving data from parsing loaders through escaping clousers
        RocketLoader().rocketDataLoad { rockets in
            DispatchQueue.main.async {
                self.rockets = rockets
            }
        }
        configurePageViewController()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func configurePageViewController() {
        guard let pageViewController =
                storyboard?.instantiateViewController(withIdentifier: String(describing: CustomPageViewController.self))
                as? CustomPageViewController else {
            return
        }
        pageViewController.delegate = self
        pageViewController.dataSource = self
        // add ChildView
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        // constraints
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.backgroundColor = UIColor.lightGray
        contentView.addSubview(pageViewController.view)
        let views: [String: Any] = ["pageView": pageViewController.view]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|",
                                                                   options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                  metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|",
                                                                  options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                  metrics: nil, views: views))
        guard let startingViewController = detailViewControllerAt(index: currentViewControllerIndex) else { return }
        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
    }
    func detailViewControllerAt(index: Int) -> DataViewController? {
        if index >= dataSource.count || dataSource.count == 0 {return nil}
        guard let dataViewController =
                storyboard?.instantiateViewController(withIdentifier: String(describing: DataViewController.self)) as? DataViewController else {return nil}
        dataViewController.index = index
        dataViewController.displayText = dataSource[index]
        return dataViewController
    }
}

extension RocketViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentViewControllerIndex
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return dataSource.count
    }
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
        return detailViewControllerAt(index: currentIndex)
    }
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let dataViewController = viewController as? DataViewController
        guard var currentIndex = dataViewController?.index else {
            return nil
        }
        if currentIndex == dataSource.count {
            return nil
        }
        currentIndex += 1
        currentViewControllerIndex = currentIndex
        return detailViewControllerAt(index: currentIndex)
    }
}
