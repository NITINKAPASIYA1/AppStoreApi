//
//  BaseTabBarController.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 15/02/25.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [
            createNavController(viewController: TodayController(), title: "Today", imageName: "text.rectangle.page"),
            createNavController(viewController: AppsPageController(), title: "Apps", imageName: "square.stack.3d.up.fill"),
            createNavController(viewController: AppSearchController(), title: "Search", imageName: "magnifyingglass"),
            createNavController(viewController: MusicController(), title: "Music", imageName: "music.note"),
        ]
        
     
    }
    
    fileprivate func createNavController(viewController:UIViewController,title:String,imageName:String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
//        viewController.view.backgroundColor = .systemBackground
        viewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem.image = UIImage(systemName: imageName)
        return navController
    }
    
    
    
}


