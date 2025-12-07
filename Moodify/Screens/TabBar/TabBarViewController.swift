//
//  TabBarControllerViewController.swift
//  CarRent
//
//  Created by Kenan Memmedov on 08.09.25.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    private func setupAppearance() {
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .gray
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .tabbar
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        setupVC()
    }
    
    private func setupVC() {
        let homeVC = HomeController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: .homeUnselectedTabIcon, selectedImage: .homeSelectedTabIcon)
        
        let exploreVC = ExploreController()
        let exploreNav = UINavigationController(rootViewController: exploreVC)
        exploreNav.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        
        let profileVC = ProfileController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        
        viewControllers = [homeNav, exploreNav, profileNav]
    }

}
