//
//  SINBaseNavigationController.swift
//  CustomNavPopGesture
//
//  Created by wf on 2018/12/5.
//  Copyright © 2018 sohu. All rights reserved.
//

import UIKit

enum TransitionType {
    case push
    case pop
}

let scale: CGFloat = 0.95

class SINBaseNavigationController: UINavigationController {

    var fullSreenPanGesture: UIPanGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.isHidden = true

        self.interactivePopGestureRecognizer!.delegate = nil
        
        self.delegate = self
        
//        fullSreenPanGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
//
//        self.view.addGestureRecognizer(fullSreenPanGesture!)
        
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOffset = CGSize(width: -2, height: 0)
        self.view.layer.shadowOpacity = 0.5
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        return super.popViewController(animated: animated)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        return super.popToRootViewController(animated: animated)
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        return super.popToViewController(viewController, animated: animated)
    }
    

    @objc private func panAction(_ pan: UIPanGestureRecognizer) {
        
    }
    
}

extension SINBaseNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        debugPrint(viewController)
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//        debugPrint(viewController)
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return nil
        
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            return CustomTransitionAnimation(.push)
        }
        
        if operation == .pop {
            return CustomTransitionAnimation(.pop)
        }
        
        return nil
        
    }
    
}

class CustomTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    var operation: TransitionType?
    
    fileprivate lazy var dimmingView: UIView = {
        let dim = UIView(frame: UIScreen.main.bounds)
        dim.backgroundColor = UIColor.black
        dim.alpha = 0
        return dim
    }()
    
    convenience init(_ transitionType: TransitionType) {
        self.init()
        operation = transitionType
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if operation == .push {
            pushAnimation(using: transitionContext)
        }
        
        if operation == .pop {
            popAnimation(using: transitionContext)
        }
        
    }
    
    private func pushAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        let fromV = transitionContext.view(forKey: .from)
        
        let toV = transitionContext.view(forKey: .to)
        
        let fromVc = transitionContext.viewController(forKey: .from)
        
        guard let fromView = fromV, let toView = toV, let fromViewController = fromVc else {
            return
        }
        
        var snapV: UIView?
        if let snapShotView = snapshotView(with: fromViewController) {
            containerView.addSubview(snapShotView)
            snapV = snapShotView
        }

        containerView.addSubview(dimmingView)
        
        containerView.addSubview(toView)
        
        let tabBar = fromViewController.tabBarController?.tabBar
        tabBar?.isHidden = true
        
        toView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            self.dimmingView.alpha = 0.25
            
            toView.transform = CGAffineTransform.identity
            
            fromView.layer.transform = CATransform3DMakeScale(scale, scale, scale)
            
            snapV?.layer.transform = CATransform3DMakeScale(scale, scale, scale)
            
        }) { (completion) in
            
            tabBar?.isHidden = false
            
            snapV?.removeFromSuperview()
            
            fromView.layer.transform = CATransform3DIdentity
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        
        
    }
    
    private func popAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        let fromV = transitionContext.view(forKey: .from)
        
        let toV = transitionContext.view(forKey: .to)
        
        let toVc = transitionContext.viewController(forKey: .to)
        
        guard let fromView = fromV, let toView = toV, let toViewController = toVc else {
            return
        }
        
        containerView.addSubview(toView)
        
        var snapV: UIView?
        if let snapShotView = snapshotView(with: toViewController) {
            containerView.addSubview(snapShotView)
            snapV = snapShotView
        }
        
//        containerView.addSubview(dimmingView)
        
        
        
//        containerView.addSubview(fromView)
        
        toView.layer.transform = CATransform3DMakeScale(scale, scale, scale)
        
        snapV?.layer.transform = CATransform3DMakeScale(scale, scale, scale)
        
        let tabBar = toViewController.tabBarController?.tabBar
        tabBar?.isHidden = true
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            self.dimmingView.alpha = 0
            
            fromView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
            
            toView.layer.transform = CATransform3DIdentity
            
            snapV?.layer.transform = CATransform3DIdentity
            
        }) { (completion) in
            
            tabBar?.isHidden = false
            
            snapV?.removeFromSuperview()
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        }
        
    }
    
    private func snapshotView(with viewController: UIViewController) -> UIView? {
        return viewController.tabBarController?.view.snapshotView(afterScreenUpdates: false)
    }
    
}


class DriveInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
    }
    
}
