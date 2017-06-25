import Foundation

let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]

func logD(_ message: String, function: String = #function) {
    #if !NDEBUG
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let date = formatter.string(from: NSDate() as Date)
        print("\(date) Func: \(function) : \(message)")
    #endif
}
