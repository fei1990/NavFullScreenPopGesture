//
//  ViewController2.swift
//  CustomNavPopGesture
//
//  Created by wf on 2018/12/5.
//  Copyright © 2018 sohu. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
//        self.view.backgroundColor = UIColor.red
        
        
//        let pushBtn = UIButton(type: .custom)
//        pushBtn.frame = CGRect(x: 100, y: 120, width: 100, height: 40)
//        pushBtn.setTitle("push", for: .normal)
//        pushBtn.setTitleColor(UIColor.black, for: .normal)
//        pushBtn.addTarget(self, action: #selector(pushAction(_:)), for: .touchUpInside)
//        self.view.addSubview(pushBtn)
//        
//        
//        let popBtn = UIButton(type: .custom)
//        popBtn.frame = CGRect(x: 100, y: 220, width: 100, height: 40)
//        popBtn.setTitle("pop", for: .normal)
//        popBtn.setTitleColor(UIColor.black, for: .normal)
//        popBtn.addTarget(self, action: #selector(pop1Action(_:)), for: .touchUpInside)
//        self.view.addSubview(popBtn)
        
    }
    

    @IBAction func popAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc private func pushAction(_ btn: UIButton) {
        let vc4 = ViewController4()
        self.navigationController?.pushViewController(vc4, animated: true)
    }
    
    @objc private func pop1Action(_ btn: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
