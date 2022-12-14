//
//  AppDelegate.swift
//  SpaceApp
//
//  Created by Григорий Душин on 11.10.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "CustomPageViewController") as? CustomPageViewController
        initialViewController?.presenter = CustomPagePresenter(rocketLoader: RocketLoader())
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        return true
    }
}
