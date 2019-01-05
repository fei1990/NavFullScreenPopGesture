//
//  ViewController5.swift
//  CustomNavPopGesture
//
//  Created by wf on 2018/12/5.
//  Copyright © 2018 sohu. All rights reserved.
//

import UIKit

class ViewController5: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func popAction(_ sender: Any) {
        
        for vc in (self.navigationController?.viewControllers)! {
            
            if vc is ViewController2 {
                
                self.navigationController?.popToViewController(vc, animated: true)
                
            }
            
        }
        
    }
    

}
