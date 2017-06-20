struct DateFormat {
    static let yyyyssDash = "yyyy-MM-dd'T'HH:mm:ss"
    static let ddmmSlash = "dd/MM/yyyy HH:mm"
    static let ddMMyyyy = "dd/MM/yyyy"
    static let yyyyMMddDash = "yyyy-MM-dd"
    static let MMyyyy = "MM/yyyy"
}

public struct GroupItem<Group, Item> {
    public var group: Group
    public var items: [Item]

    public init(group: Group, items: [Item]) {
        self.group = group
        self.items = items
    }
}
