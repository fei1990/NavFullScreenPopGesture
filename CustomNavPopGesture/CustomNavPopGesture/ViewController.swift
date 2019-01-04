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
    
    lazy private var imgView: UIImageView = {
        return UIImageView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lbl = UILabel(frame: CGRect(x: 100, y: 120, width: 100, height: 30))
        lbl.text = "fdsfjdsfjldsjfldsf"
        lbl.backgroundColor = UIColor.cyan
        self.view.addSubview(lbl)
        
        
        let img = generateSnapView((self.tabBarController?.view)!)
//        imgView.backgroundColor = UIColor.red
        imgView.image = img

        imgView.frame = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        
        view.addSubview(imgView)
        
//        let v = clipView()
//
//        view.addSubview(v)
        
//        let btn = UIButton.init(type: .system)
//        btn.setTitle("push", for: .normal)
//        btn.titleLabel?.textColor = UIColor.black
//        btn.frame = CGRect(x: 20, y: 100, width: 100, height: 30)
//        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
//        self.view.addSubview(btn)
    }


    @objc private func btnAction(_ btn: UIButton) {
//        self.navigationController?.delegate = self.navigationController as? SINBaseNavigationController
        let vc2 = ViewController2()
        self.navigationController?.pushViewController(vc2, animated: true)
    }
    
    private func generateSnapView(_ view: UIView) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let snapImg = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return snapImg!
        
    }
    
    private func generateImage(_ image: UIImage) -> UIImage {
        
        //输出尺寸
        let outputRect = CGRect(x: 0, y: UIScreen.main.bounds.height - 84, width: UIScreen.main.bounds.width, height: 84)
        
        //开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可）
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        //添加裁剪区域
        context.addRect(outputRect)
        context.clip()
//        image.draw(in: outputRect)
        image.draw(in: outputRect, blendMode: .color, alpha: 1)
        //获得处理后的图片
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return maskedImage
    }
    
    private func generateSnapView1(_ view: UIView) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, UIScreen.main.scale)
        
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let snapImg = UIGraphicsGetImageFromCurrentImageContext()
        
        let finalImageRef = snapImg?.cgImage?.cropping(to: CGRect(x: 0, y: UIScreen.main.bounds.height - 84, width: UIScreen.main.bounds.width, height: 84))
        
        let finalImg = UIImage(cgImage: finalImageRef!, scale: (snapImg?.scale)!, orientation: (snapImg?.imageOrientation)!)
        
        UIGraphicsEndImageContext()
        
        return finalImg
        
    }
    
    
    private func clipView() -> UIView {
        
        let v = self.tabBarController?.view
        
        let bezierPath = UIBezierPath(rect: CGRect(x: 0, y: v!.bounds.height - 84, width: v!.bounds.width, height: 84))
        
        let shapLayer = CAShapeLayer()
        shapLayer.frame = (v?.frame)!
        shapLayer.path = bezierPath.cgPath
        v?.layer.mask = shapLayer
        
        return v!
        
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
