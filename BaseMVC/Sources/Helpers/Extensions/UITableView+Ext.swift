import UIKit

extension UITableView {

    func registerNibCellBy(indentifier: String) {
        self.register(UINib(nibName: indentifier, bundle: nil), forCellReuseIdentifier: indentifier)
    }

    func registerNibHeaderViewBy(indentifier: String) {
        self.register(UINib(nibName: indentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: indentifier)
    }

    func hideEmptyCells() {
        self.tableFooterView = UIView(frame: .zero)
    }
}
