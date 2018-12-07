//
//  ViewController.swift
//  CustomNavPopGesture
//
//  Created by wf on 2018/12/5.
//  Copyright © 2018 sohu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lbl = UILabel(frame: CGRect(x: 100, y: 120, width: 100, height: 30))
        lbl.text = "fdsfjdsfjldsjfldsf"
        lbl.backgroundColor = UIColor.cyan
        self.view.addSubview(lbl)
        
        
//        let btn = UIButton.init(type: .custom)
//        btn.titleLabel?.text = "push"
//        btn.titleLabel?.textColor = UIColor.black
//        btn.frame = CGRect(x: 20, y: 100, width: 100, height: 30)
//        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
//        self.view.addSubview(btn)
    }


    @objc private func btnAction(_ btn: UIButton) {
        let vc2 = ViewController2()
        self.navigationController?.pushViewController(vc2, animated: true)
    }
    
}

