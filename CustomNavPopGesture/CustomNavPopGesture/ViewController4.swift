//
//  ViewController4.swift
//  CustomNavPopGesture
//
//  Created by wf on 2018/12/5.
//  Copyright © 2018 sohu. All rights reserved.
//

import UIKit

class ViewController4: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    

    @IBAction func popAction(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        
        for vc in (self.navigationController?.viewControllers)! {
            if let v = vc as? ViewController {
                self.navigationController?.popToViewController(v, animated: true)
            }
        }
        
//        self.navigationController?.popToRootViewController(animated: true)
    }
    

}
