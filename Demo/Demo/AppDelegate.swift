//
//  AppDelegate.swift
//  Demo
//
//  Created by zgjff on 2022/7/30.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) {
            window?.backgroundColor = .systemBackground
        } else {
            window?.backgroundColor = .black
        }
        window?.rootViewController = UINavigationController(rootViewController: ViewController())
        window?.makeKeyAndVisible()
        DispatchQueue.main.async {
            self.registerRouters()
        }
        return true
    }
}

extension AppDelegate {
    private func registerRouters() {
        SimpleRouter.allCases.forEach { try! $0.register() }
        BlockRouter.allCases.forEach { try! $0.register() }
        PassParameterRouter.allCases.forEach { try! $0.register() }
    }
}
