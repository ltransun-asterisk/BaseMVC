public struct GroupItem<Group, Item> {
    public var group: Group
    public var items: [Item]

    public init(group: Group, items: [Item]) {
        self.group = group
        self.items = items
    }
}
