//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Артур Гайфуллин on 04.04.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let viewController = TabBarController()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        self.window = window
    }
}

