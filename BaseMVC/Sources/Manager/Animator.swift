import UIKit

public enum AnimationType {
    case push
    case pop
    case present
    case dismiss
    case none
}

class Animator: NSObject, UIViewControllerAnimatedTransitioning {

    var presentedType: AnimationType = .push
    var dismissedType: AnimationType = .pop
    var animateType: AnimationType = .none
    var transitionDuration: TimeInterval = 0.33

    // MARK: Init
    override init() {

    }

    init(presentedType: AnimationType, dismissedType: AnimationType) {
        self.presentedType = presentedType
        self.dismissedType = dismissedType
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch animateType {
        case .push:
            self.pushAnimation(transitionContext)
        case .pop:
            self.popAnimation(transitionContext)
        default:
            self.pushAnimation(transitionContext)
        }
    }

    private func pushAnimation(_ transitionContext: UIViewControllerContextTransitioning) {

        // get viewControllers
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView

        // set frame
        let bounds = UIScreen.main.bounds
        toViewController.view.frame = finalFrameForVC.offsetBy(dx: bounds.size.width, dy: 0)
        toViewController.view.clipsToBounds = true
        containerView.addSubview(toViewController.view)

        // animate
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveLinear, animations: {

            fromViewController.view.alpha = 0.5
            toViewController.view.frame = finalFrameForVC

        }) { (_ ) in
            transitionContext.completeTransition(true)
            fromViewController.view.alpha = 1.0
        }
    }

    private func popAnimation(_ transitionContext: UIViewControllerContextTransitioning) {

         // get viewControllers
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView

        // set frame
        toViewController.view.frame = finalFrameForVC
        toViewController.view.alpha = 0.5
        containerView.addSubview(toViewController.view)
        containerView.sendSubview(toBack: toViewController.view)

        // create view by snapshot
        let snapshotView = fromViewController.view.snapshotView(afterScreenUpdates: false)
        snapshotView?.frame = fromViewController.view.frame
        containerView.addSubview(snapshotView!)

        fromViewController.view.removeFromSuperview()

        // animate
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            let bounds = UIScreen.main.bounds
            snapshotView?.frame = finalFrameForVC.offsetBy(dx: bounds.size.width, dy: 0)

            toViewController.view.alpha = 1.0

        }, completion: { _ in
            snapshotView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}
