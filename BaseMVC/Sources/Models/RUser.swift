import Foundation
import RealmSwift

class RUser: Object {

    dynamic var id: String?

    dynamic var userName: String?

    let height = RealmOptional<Int>()

    dynamic var email: String?

    dynamic var accessToken: String?

    let isCurrent = RealmOptional<Bool>()

    dynamic var store: RStore?

    override static func primaryKey() -> String? {
        return "id"
    }

}
