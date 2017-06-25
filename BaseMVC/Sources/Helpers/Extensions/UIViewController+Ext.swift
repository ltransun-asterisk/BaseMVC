import UIKit

// MARK: UIViewController
extension UIViewController {

    static func getViewControllerFromStoryboard(_ storyboardName: String) -> UIViewController {
        let identifier = String(describing: self)
        return self.getViewControllerWithIdentifier(identifier, storyboardName: storyboardName)
    }

    static func getNavigationControllerFromStoryboard(_ storyboardName: String) -> UIViewController {
        let identifier = String(describing: self) + "Nav"
        return self.getViewControllerWithIdentifier(identifier, storyboardName: storyboardName)
    }

    static func getViewControllerWithIdentifier(_ identifier: String, storyboardName: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}

extension UIViewController {
    func showAlertWith(title: String?, message: String?, titleDefault: String?, handlerDefault: ((UIAlertAction) -> Swift.Void)? = nil) {
        // alert
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertVC.addAction(UIAlertAction(title: titleDefault, style: UIAlertActionStyle.default, handler: handlerDefault))
        // present
        self.present(alertVC, animated: true, completion: nil)
    }
}
