import Foundation
import RealmSwift

class RStore: Object {

        dynamic var id: String?

        dynamic var name: String?

        let user = LinkingObjects(fromType: RUser.self, property: "store")

        override static func primaryKey() -> String? {
            return "id"
        }

}
