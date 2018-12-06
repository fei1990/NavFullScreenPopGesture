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
let dimmingViewAlpha: CGFloat = 0.25

class SINBaseNavigationController: UINavigationController {

    var transitionType: Operation = .push
    
    var fullSreenPanGesture: UIPanGestureRecognizer!
    
    ///是否向右拖动
    private var isHorPan: Bool {
        
        let point: CGPoint = fullSreenPanGesture.translation(in: fullSreenPanGesture.view)
        
        let absX = abs(point.x)
        let absY = abs(point.y)
        
        if absX >= absY && point.x > 0 {
            return true
        }
        
        return false
    }
    
    ///截取带tabBar的view
    private var snapshopView: UIView?
    
    private lazy var interactiveTransition: DriveInteractiveTransition = {
        let transition = DriveInteractiveTransition(fullSreenPanGesture)
        return transition
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.isHidden = true

//        self.interactivePopGestureRecognizer!.delegate = nil
        
        self.delegate = self
        
        self.interactivePopGestureRecognizer?.isEnabled = false
        
        for ges in self.view.gestureRecognizers! {
            if let g = ges as? UIScreenEdgePanGestureRecognizer {
                g.isEnabled = false
            }
        }
        
        fullSreenPanGesture = UIPanGestureRecognizer(target: self, action: #selector(panForPopAction(_:)))
        self.view.addGestureRecognizer(fullSreenPanGesture)
        
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
    

    @objc private func panForPopAction(_ pan: UIPanGestureRecognizer) {

        if isHorPan {
            switch pan.state {
            case .possible,.began:
                
                self.interactiveTransition.panGesture = fullSreenPanGesture
                let _ = popViewController(animated: true)
            case .changed:
                
                break
            case .ended, .cancelled, .failed:
                self.interactiveTransition.panGesture = nil
                break
            default:
                break
            }
        }else {
            self.interactiveTransition.panGesture = nil
        }

    }
    
}

extension SINBaseNavigationController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {

    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        guard let _ = self.interactiveTransition.panGesture, transitionType == .pop else {
            return nil
        }
        
        return interactiveTransition
        
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transitionType = operation
        
        if operation == .push {
            if self.viewControllers.count == 2 {
                snapshopView = self.tabBarController?.view.snapshotView(afterScreenUpdates: false)
                return CustomTransitionAnimation(.push, snapshopView: snapshopView)
            }else {
                return CustomTransitionAnimation(.push)
            }
        }
        
        if operation == .pop {
            if self.viewControllers.count == 1 {
                return CustomTransitionAnimation(.pop, snapshopView: snapshopView)
            }else if self.viewControllers.count > 1 {
                return CustomTransitionAnimation(.pop)
            }else {
                return nil
            }
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
    
    var snapshotView: UIView?
    
    
    convenience init(_ transitionType: TransitionType, snapshopView: UIView? = nil) {
        self.init()
        operation = transitionType
        self.snapshotView = snapshopView
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
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
        
        setViewShadow(toView)
        
        let tabBar = fromViewController.tabBarController?.tabBar
        if let snap = snapshotView {
            containerView.addSubview(snap)
            tabBar?.isHidden = true
        }

        containerView.addSubview(dimmingView)
        
        containerView.addSubview(toView)
        
        toView.transform = CGAffineTransform(translationX: toView.bounds.width, y: 0)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {
            self.dimmingView.alpha = dimmingViewAlpha
            
            toView.transform = CGAffineTransform.identity
            
            fromView.layer.transform = CATransform3DMakeScale(scale, scale, scale)
            
            self.snapshotView?.layer.transform = CATransform3DMakeScale(scale, scale, scale)
        }) { (complete) in
            tabBar?.isHidden = false
            
            self.snapshotView?.removeFromSuperview()
            
            self.dimmingView.removeFromSuperview()
            
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
        
        setViewShadow(fromView)
        
        containerView.insertSubview(toView, belowSubview: fromView)
        
        let tabBar = toViewController.tabBarController?.tabBar
        if let snap = snapshotView {
            containerView.insertSubview(snap, aboveSubview: toView)
            tabBar?.isHidden = true
            containerView.insertSubview(dimmingView, aboveSubview: snap)
        }else {
            containerView.insertSubview(dimmingView, aboveSubview: toView)
        }
        
        toView.layer.transform = CATransform3DMakeScale(scale, scale, scale)
        
        snapshotView?.layer.transform = CATransform3DMakeScale(scale, scale, scale)
        
        dimmingView.alpha = dimmingViewAlpha
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {
            self.dimmingView.alpha = 0
            
            fromView.transform = CGAffineTransform(translationX: fromView.bounds.width, y: 0)
            
            toView.layer.transform = CATransform3DIdentity
            
            self.snapshotView?.layer.transform = CATransform3DIdentity
        }) { (complete) in
            tabBar?.isHidden = false
            
            self.snapshotView?.removeFromSuperview()
            
            self.dimmingView.removeFromSuperview()
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
    private func setViewShadow(_ view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: -2, height: 0)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }
    
    private func navigationControllerSnapshotView(with viewController: UIViewController) -> UIView? {
        return viewController.navigationController?.view.snapshotView(afterScreenUpdates: false)
    }
    
}


class DriveInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    var panGesture: UIPanGestureRecognizer?
    
    convenience init(_ gesture: UIPanGestureRecognizer) {
        self.init()
        panGesture = gesture
        panGesture?.addTarget(self, action: #selector(panForInteractiveTransition(_:)))
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
        completionSpeed = (1 - percentComplete)*duration
        completionCurve = .easeIn
    }
    
    @objc private func panForInteractiveTransition(_ pan: UIPanGestureRecognizer) {
        
        let scale = percentForGesture(pan)
//        print("percentComplete : \(percentComplete)")
        print("scale : \(scale)")
        switch pan.state {
        case .began, .possible, .changed:
            update(scale)
        case .ended:
            
            if scale < 0.3 {
                cancel()
            }else {
                completionSpeed = 0.7
                finish()
            }

        default:
            break
        }

    }
    
    private func percentForGesture(_ ges: UIPanGestureRecognizer) -> CGFloat {
        
        let transition = ges.translation(in: ges.view)
        
        var scale = transition.x / UIScreen.main.bounds.width
        print(transition.x)

        scale = scale < 0 ? 0 : scale
        
        scale = scale > 1 ? 1 : scale
        
        return scale
    }
    
    
    
}
