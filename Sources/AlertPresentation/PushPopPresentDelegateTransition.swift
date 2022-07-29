//
//  PushPopPresentDelegateTransition.swift
//  JJBlockRouter-Demo
//
//  Created by zgjff on 2022/6/11.
//

import UIKit

/// 提供使present/dismiss动画跟系统push/pop动画一致的转场动画
public protocol PushPopStylePresentDelegate: UIViewController {
    var pushPopStylePresentDelegate: PushPopPresentTransitionDelegate { get }
}

private var pushPopStylePresentDelegateKey: Void?

extension PushPopStylePresentDelegate {
    /// PushPopStylePresentDelegate属性
    public var pushPopStylePresentDelegate: PushPopPresentTransitionDelegate {
        get {
            if let associated = objc_getAssociatedObject(self, &pushPopStylePresentDelegateKey) as? PushPopPresentTransitionDelegate { return associated }
            let associated = PushPopPresentTransitionDelegate()
            objc_setAssociatedObject(self, &pushPopStylePresentDelegateKey, associated, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return associated
        }
        set {
            objc_setAssociatedObject(self, &pushPopStylePresentDelegateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension PushPopStylePresentDelegate {
    /// 开始跟系统pop一样的动画的dismiss
    /// - Parameters:
    ///   - gesture: UIScreenEdgePanGestureRecognizer手势
    ///   - animated: 是否动画
    ///   - completion: 回调
    public func popStyleDismiss(with gesture: UIScreenEdgePanGestureRecognizer? = nil, animated: Bool = true, completion: (()-> ())?) {
        if let navit = navigationController?.transitioningDelegate as? PushPopPresentTransitionDelegate {
            navit.targetEdge = .left
            navit.gestureRecognizer = gesture
            navigationController?.dismiss(animated: animated, completion: completion)
            return
        }
        if let t = transitioningDelegate as? PushPopPresentTransitionDelegate {
            t.targetEdge = .left
            t.gestureRecognizer = gesture
            dismiss(animated: animated, completion: completion)
            return
        }
        dismiss(animated: animated, completion: completion)
    }
}

extension PushPopStylePresentDelegate {
    /// 添加跟系统push一样的动画的presetn
    public func addScreenPanGestureDismiss() {
        let spGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(onBeganEdgePanGestureBack(_:)))
        spGesture.edges = .left
        view.addGestureRecognizer(spGesture)
    }
}

extension UIViewController {
    @IBAction fileprivate func onBeganEdgePanGestureBack(_ sender: UIScreenEdgePanGestureRecognizer) {
        guard case .began = sender.state else {
            return
        }
        if let svc = self as? PushPopStylePresentDelegate {
            svc.popStyleDismiss(with: sender, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

public class PushPopPresentTransitionDelegate: NSObject {
    public var gestureRecognizer: UIScreenEdgePanGestureRecognizer?
    public var targetEdge: UIRectEdge = .right
}

extension PushPopPresentTransitionDelegate: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = SwipeTransitionAnimator(edge: targetEdge)
        animator.transitionCompleted = { [weak self] in
            self?.targetEdge = .left
        }
        return animator
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = SwipeTransitionAnimator(edge: targetEdge)
        animator.transitionCompleted = { [weak self] in
            self?.targetEdge = .left
        }
        return animator
    }
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let ges = gestureRecognizer {
            return SwipeDrivenTransition(gestureRecognizer: ges, edgeForDragging: targetEdge)
        } else {
            return nil
        }
    }
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let ges = gestureRecognizer {
            return SwipeDrivenTransition(gestureRecognizer: ges, edgeForDragging: targetEdge)
        } else {
            return nil
        }
    }
}

private final class SwipeDrivenTransition: UIPercentDrivenInteractiveTransition {
    init(gestureRecognizer: UIScreenEdgePanGestureRecognizer, edgeForDragging edge: UIRectEdge) {
        assert(edge == .top || edge == .bottom || edge == .left || edge == .right, "targetEdge must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.")
        self.gestureRecognizer = gestureRecognizer
        self.edge = edge
        super.init()
        gestureRecognizer.addTarget(self, action: #selector(gestureRecongnizeDidUpdate(_:)))
    }
    
    private let gestureRecognizer: UIScreenEdgePanGestureRecognizer
    private let edge: UIRectEdge
    private weak var transitionContext: UIViewControllerContextTransitioning?
    deinit {
        gestureRecognizer.removeTarget(self, action: #selector(gestureRecongnizeDidUpdate(_:)))
    }
}


extension SwipeDrivenTransition {
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        super.startInteractiveTransition(transitionContext)
    }
    
    @IBAction private func gestureRecongnizeDidUpdate(_ sender: UIScreenEdgePanGestureRecognizer) {
        switch sender.state {
        case .began:
            return
        case .changed:
            update(percentForGesture(sender))
        case .ended:
            if percentForGesture(sender) >= 0.5 {
                finish()
            } else {
                cancel()
            }
        default:
            cancel()
        }
    }
    
    private func percentForGesture(_ sender: UIScreenEdgePanGestureRecognizer) -> CGFloat {
        guard let transitionContainerView = transitionContext?.containerView else { return 0 }
        let location = sender.location(in: transitionContainerView)
        
        let width = transitionContainerView.bounds.width
        let height = transitionContainerView.bounds.height
        
        switch edge {
        case .right:
            return (width - location.x) / width
        case .left:
            return location.x / width
        case .bottom:
            return (height - location.y) / height
        case .top:
            return location.y / height
        default:
            return 0
        }
    }
}

private final class SwipeTransitionAnimator: NSObject {
    var transitionCompleted: (() -> ())?
    init(edge: UIRectEdge) {
        self.targetEdge = edge
        super.init()
    }
    private let targetEdge: UIRectEdge
}

extension SwipeTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return (transitionContext?.isAnimated ?? true) ? 0.25 : 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else { return }
        if fromVC.modalPresentationStyle == .custom || toVC.modalPresentationStyle == .custom {
            return customModalPresentationStyleAnimateTransition(using: transitionContext)
        } else {
            return systemModalPresentationStyleAnimateTransition(using: transitionContext)
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        self.transitionCompleted?()
    }
}

private extension SwipeTransitionAnimator {
    func systemModalPresentationStyleAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else { return }
        let duration = transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView
        var fromView, toView: UIView
        if transitionContext.responds(to: #selector(transitionContext.view(forKey:))) {
            //TODO: 适配iOS13
            fromView = transitionContext.view(forKey: .from) ?? fromVC.view!
            toView = transitionContext.view(forKey: .to) ?? toVC.view!
        } else {
            fromView = fromVC.view
            toView = toVC.view
        }
        
        let isPresenting = toVC.presentingViewController == fromVC
        
        let startFrame = transitionContext.initialFrame(for: fromVC)
        let endFrame = transitionContext.finalFrame(for: toVC)
        
        var offset: CGVector
        switch targetEdge {
        case .top:
            offset = CGVector(dx: 0, dy: 1)
        case .bottom:
            offset = CGVector(dx: 0, dy: -1)
        case .left:
            offset = CGVector(dx: 1, dy: 0)
        case .right:
            offset = CGVector(dx: -1, dy: 0)
        default:
            offset = CGVector()
            assert(false, "targetEdge must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.")
        }
        
        if isPresenting {
            fromView.frame = startFrame
            toView.frame = endFrame.offsetBy(dx: endFrame.width * offset.dx * -1, dy: endFrame.height * offset.dy * -1)
        } else {
            fromView.frame = startFrame
            toView.frame = endFrame.offsetBy(dx: endFrame.width * -0.3, dy: 0)
        }
        
        if isPresenting {
            toView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
            toView.layer.shadowOffset = CGSize(width: -1, height: 1)
            toView.layer.shadowRadius = 1
            toView.layer.shadowOpacity = 1
            toView.layer.shadowPath = UIBezierPath(rect: toView.bounds).cgPath
            toView.clipsToBounds = false
        } else {
            fromView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
            fromView.layer.shadowOffset = CGSize(width: -1, height: 1)
            fromView.layer.shadowRadius = 1
            fromView.layer.shadowOpacity = 1
            fromView.layer.shadowPath = UIBezierPath(rect: toView.bounds).cgPath
            fromView.clipsToBounds = false
        }
        
        if isPresenting {
            containerView.addSubview(toView)
        } else {
            containerView.insertSubview(toView, belowSubview: fromView)
        }
        if !transitionContext.isInteractive {
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
                if isPresenting {
                    toView.frame = endFrame
                    fromView.frame = startFrame.offsetBy(dx: startFrame.width * -0.3, dy: 0)
                } else {
                    fromView.frame = startFrame.offsetBy(dx: startFrame.width * offset.dx, dy: startFrame.height * offset.dy)
                    toView.frame = endFrame
                }
            } completion: { _ in
                let wasCancelled = transitionContext.transitionWasCancelled
                if wasCancelled {
                    toView.removeFromSuperview()
                }
                transitionContext.completeTransition(!wasCancelled)
            }
            return
        }
        UIView.animate(withDuration: duration, animations: {
            if isPresenting {
                toView.frame = endFrame
                fromView.frame = startFrame.offsetBy(dx: startFrame.width * -0.3, dy: 0)
            } else {
                fromView.frame = startFrame.offsetBy(dx: startFrame.width * offset.dx, dy: startFrame.height * offset.dy)
                toView.frame = endFrame
            }
        }) { _ in
            let wasCancelled = transitionContext.transitionWasCancelled
            if wasCancelled {
                toView.removeFromSuperview()
            }
            transitionContext.completeTransition(!wasCancelled)
        }
    }
    
    func customModalPresentationStyleAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else { return }
        let duration = transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView
        var fromView, toView: UIView
        if transitionContext.responds(to: #selector(transitionContext.view(forKey:))) {
            //TODO: 适配iOS13
            fromView = transitionContext.view(forKey: .from) ?? fromVC.view!
            toView = transitionContext.view(forKey: .to) ?? toVC.view!
        } else {
            fromView = fromVC.view
            toView = toVC.view
        }
        
        let isPresenting = toVC.presentingViewController == fromVC
        
        let startFrame = fromVC.presentationController?.frameOfPresentedViewInContainerView ?? transitionContext.initialFrame(for: fromVC)
        let endFrame = toVC.presentationController?.frameOfPresentedViewInContainerView ?? transitionContext.finalFrame(for: toVC)
        
        var offset: CGVector
        switch targetEdge {
        case .top:
            offset = CGVector(dx: 0, dy: 1)
        case .bottom:
            offset = CGVector(dx: 0, dy: -1)
        case .left:
            offset = CGVector(dx: 1, dy: 0)
        case .right:
            offset = CGVector(dx: -1, dy: 0)
        default:
            offset = CGVector()
            assert(false, "targetEdge must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.")
        }
        
        if isPresenting {
            toView.frame = endFrame.offsetBy(dx: endFrame.width * offset.dx * -1, dy: endFrame.height * offset.dy * -1)
        } else {
            fromView.frame = startFrame
        }
        if isPresenting {
            containerView.addSubview(toView)
        }
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
            if isPresenting {
                toView.frame = endFrame
            } else {
                fromView.frame = startFrame.offsetBy(dx: startFrame.width * offset.dx, dy: startFrame.height * offset.dy)
            }
        } completion: { _ in
            let wasCancelled = transitionContext.transitionWasCancelled
            if wasCancelled {
                toView.removeFromSuperview()
            }
            transitionContext.completeTransition(!wasCancelled)
        }
    }
}
