//
//  ViewController.swift
//  CustomNavPopGesture
//
//  Created by wf on 2018/12/5.
//  Copyright © 2018 sohu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    var ff = fff()
    
//    lazy private var imgView: UIImageView = {
//        return UIImageView()
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lbl = UILabel(frame: CGRect(x: 100, y: 120, width: 100, height: 30))
        lbl.text = "fdsfjdsfjldsjfldsf"
        lbl.backgroundColor = UIColor.cyan
        self.view.addSubview(lbl)
        
//        let btn = UIButton.init(type: .system)
//        btn.setTitle("push", for: .normal)
//        btn.titleLabel?.textColor = UIColor.black
//        btn.frame = CGRect(x: 20, y: 100, width: 100, height: 30)
//        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
//        self.view.addSubview(btn)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }


    @objc private func btnAction(_ btn: UIButton) {
        let vc2 = ViewController2()
        self.navigationController?.pushViewController(vc2, animated: true)
    }
    
}

//class fff: NSObject, UINavigationControllerDelegate {
//
//    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
////        if operation == .push {
////            return qq()
////        }
//        return nil
//    }
//
//}
//
//class qq: NSObject, UIViewControllerAnimatedTransitioning {
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//
//        return 0.3
//    }
//
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//
//
//    }
//}
