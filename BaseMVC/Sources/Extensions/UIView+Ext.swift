import UIKit

extension UIView {

    class func fromNib<T: UIView>() -> T? {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.first as? T
    }
}
