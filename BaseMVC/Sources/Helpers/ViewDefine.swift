// MARK: - Storyboard
struct Storyboard {

    struct Main {
        static let name                         = "Main"
        static let startViewController          = "StartViewController"
    }

    struct User {
        static let name                         = "User"
        static let loginViewController          = "LoginViewController"
    }

    struct Timeline {
        static let name                         = "Timeline"
    }

    struct Message {
        static let name                         = "Message"
    }
}

struct ReuseView {
    static let leftMenuCell                     = "LeftMenuCell"
}

struct SegueIdentifier {
    static let gotoMainApp                       = "gotoMainApp"
}
