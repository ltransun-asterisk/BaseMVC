import Foundation

extension String {

    var localized: String {
        return self.localizedWithComment(comment: "")
    }

    func localizedWithComment(comment: String) -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
