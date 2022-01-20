//
//  AppDelegate.swift
//  GoraStudioTestAssignment
//
//  Created by Vladimir Banushkin on 19.01.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let usersListVC = UsersListViewController()
        let navigationCOntroller = UINavigationController(rootViewController: usersListVC)
        window.rootViewController = navigationCOntroller
        self.window = window
        window.makeKeyAndVisible()
        window.overrideUserInterfaceStyle = .light
        return true
    }

}

