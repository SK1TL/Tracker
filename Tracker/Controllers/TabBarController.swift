//
//  ViewController.swift
//  Tracker
//
//  Created by Артур Гайфуллин on 04.04.2024.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = .YPWhite
        tabBar.tintColor = .YPBlue
        tabBar.unselectedItemTintColor = .YPGray
        
        tabBar.layer.borderWidth = 0.50
        tabBar.layer.borderColor = UIColor.black.cgColor
        tabBar.clipsToBounds = true
        
        let trackerViewController = UINavigationController(rootViewController: TrackerViewController())
        
        trackerViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "trackersButton")?.withTintColor(.YPGray),
            selectedImage: UIImage(named: "trackersButton")?.withTintColor(.YPBlue)
        )
        
        let statisticViewController = UINavigationController(rootViewController: StatisticViewController())
        
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "statisticButton")?.withTintColor(.YPGray),
            selectedImage: UIImage(named: "statisticButton")?.withTintColor(.YPBlue)
        )
        
        selectedIndex = 0
        viewControllers = [trackerViewController, statisticViewController]
    }
}
