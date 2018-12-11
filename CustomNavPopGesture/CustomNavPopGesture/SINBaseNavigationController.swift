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
    
    /// 全屏滑动pop手势 替换navigation自带的边缘侧滑手势
    var fullSreenPanGesture: UIPanGestureRecognizer!
    
    /// 是否正在拖拽pop
    var isDraggingPop: Bool = false
    
    ///是否向右拖动
    private var isHorPan: Bool {
        
        let point: CGPoint = fullSreenPanGesture.translation(in: fullSreenPanGesture.view)
        
        let absX = abs(point.x)
        let absY = abs(point.y)
        
        if absX >= absY {
            return true
        }
        
        return false
    }
    
    ///截取带tabBar的view
    private var snapshopView: UIView?
    
    /// 交互转场实例
    private lazy var interactiveTransition: DriveInteractiveTransition = {
        let driveTransition = DriveInteractiveTransition(fullSreenPanGesture)
        return driveTransition
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("navigationTransitionCompleted"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.isHidden = true
        
        self.delegate = self
        
        ///禁用系统自带的边缘侧滑返回手势
        for ges in self.view.gestureRecognizers! {
            if let g = ges as? UIScreenEdgePanGestureRecognizer {
                g.isEnabled = false
            }
        }
        
        fullSreenPanGesture = UIPanGestureRecognizer(target: self, action: #selector(panForPopAction(_:)))
        self.view.addGestureRecognizer(fullSreenPanGesture)
        fullSreenPanGesture.isEnabled = false  //导航控制器栈只有一个viewcontroller时禁止手势
        
        NotificationCenter.default.addObserver(self, selector: #selector(transitionCompletionNotification(_:)), name: NSNotification.Name(rawValue: "navigationTransitionCompleted"), object: nil)
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {

        let poppedVc = super.popViewController(animated: animated)
        
        return poppedVc
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        
        let vcs = super.popToRootViewController(animated: animated)
        
        return vcs
        
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let poppedVc = super.popToViewController(viewController, animated: animated)
        return poppedVc
    }
    

    @objc private func panForPopAction(_ pan: UIPanGestureRecognizer) {

        if isHorPan {
            switch pan.state {
            case .began:
                if isDraggingPop == false {
                    let _ = popViewController(animated: true)
                    isDraggingPop = true
                }
            case .changed:
                
                break
            case .ended, .cancelled, .failed:
                isDraggingPop = false
            default:
                break
            }
        }

    }
    
    @objc private func transitionCompletionNotification(_ notification: Notification) {
//        print(viewControllers)
        if viewControllers.count == 1 {  //栈里只有一个vc 禁用手势
            fullSreenPanGesture.isEnabled = false
        }else {  //多于一个vc时才打开手势
            if fullSreenPanGesture.isEnabled == false {
                fullSreenPanGesture.isEnabled = true
            }
        }
    }
    
}

extension SINBaseNavigationController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {

    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if fullSreenPanGesture.state == .began {
            return interactiveTransition
        }
        
        return nil
        
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            //第一次push的时候需要把截取tabBar的view做动画
            if self.viewControllers.count == 2 {
                snapshopView = self.tabBarController?.view.snapshotView(afterScreenUpdates: false)
                return CustomTransitionAnimation(.push, snapshopView: snapshopView)
            }else {
                return CustomTransitionAnimation(.push)
            }
        }
        
        if operation == .pop {
            //当pop到root vc的时候也需要在截取的tabBar的view上做动画
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
    
    func animationEnded(_ transitionCompleted: Bool) {
//        print("completion........")
        if transitionCompleted {
            NotificationCenter.default.post(name: NSNotification.Name("navigationTransitionCompleted"), object: nil)
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
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: {
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
            
            fromView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
            
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
    
    private var panGesture: UIPanGestureRecognizer?
    
    /// 交互是否已经完成
    private var isInteractiveFinished: Bool = false
    
    /// 交互是否取消
    private var isInteractiveCanceled: Bool = false
    
    private var start: CFAbsoluteTime = 0
    
    private var end: CFAbsoluteTime = 0
    
    convenience init(_ gesture: UIPanGestureRecognizer) {
        self.init()
        panGesture = gesture
        panGesture?.addTarget(self, action: #selector(panForInteractiveTransition(_:)))
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
        isInteractiveFinished = false
        isInteractiveCanceled = false
        start = CFAbsoluteTimeGetCurrent()
    }
    
    @objc private func panForInteractiveTransition(_ pan: UIPanGestureRecognizer) {
        
        let scale = percentForGesture(pan)

        switch pan.state {
        case .began:
            
            break
        case .changed:
            if isInteractiveCanceled == false && isInteractiveFinished == false {
                update(scale)
            }
        case .ended, .failed, .cancelled:
            end = CFAbsoluteTimeGetCurrent()
            if (end - start) * 1000 <= 68 {
                if isInteractiveCanceled == false {
                    completionSpeed = 0.7
                    completionCurve = .easeInOut
                    finish()
                    isInteractiveFinished = true
                }
            }else {
                if scale <= 0.3 {
                    if isInteractiveFinished == false {
                        completionSpeed = (1 - percentComplete)*duration
                        completionCurve = .easeInOut
                        cancel()
                        isInteractiveCanceled = true
                    }
                }else {
                    if isInteractiveCanceled == false {
                        completionSpeed = 0.7
                        completionCurve = .easeInOut
                        finish()
                        isInteractiveFinished = true
                    }
                }
            }

        default:
            break
        }

    }
    
    private func percentForGesture(_ ges: UIPanGestureRecognizer) -> CGFloat {
        
        let transition = ges.translation(in: ges.view)
        
        var scale = transition.x / UIScreen.main.bounds.width
        
        scale = scale < 0 ? 0 : scale
        
        scale = scale > 1 ? 1 : scale
        
        return scale
    }

}
