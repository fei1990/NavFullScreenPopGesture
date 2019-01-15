//
//  SINBaseTabBarViewController.swift
//  CustomNavPopGesture
//
//  Created by wf on 2019/1/9.
//  Copyright © 2019 sohu. All rights reserved.
//

import UIKit

class SINBaseTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self

    }
    
    
}


extension SINBaseTabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return nil
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let transition = CATransition()
        transition.type = .fade
        tabBarController.view.layer.add(transition, forKey: nil)
        
    }
    
}
