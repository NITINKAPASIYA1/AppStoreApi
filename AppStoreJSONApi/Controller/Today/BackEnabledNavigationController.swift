//
//  BackEnabledNavigationController.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 25/02/25.
//

import UIKit

class BackEnabledNavigationController: UINavigationController , UIGestureRecognizerDelegate{
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.viewControllers.count > 1
    }

}

