import Foundation

//class Formatter: NSObject {
//    static let shared = Formatter()
//
//    let dateFormatter = DateFormatter()
//
//    private override init() {
//        super.init()
//        dateFormatter.timeZone = NSTimeZone.default
//        dateFormatter.locale = NSLocale(localeIdentifier: Constant.defaultDateLocale) as Locale!
//    }
//}

extension Date {

    // MARK: - Date
    static func convertDateToString(fromDate: Date?, format: String) -> String? {
        if let convertDate = fromDate {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone.default
            dateFormatter.locale = NSLocale(localeIdentifier: Constant.defaultDateLocale) as Locale!
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: convertDate)
        } else {
            return nil
        }
    }

    static func convertStringToDate(fromString: String?, format: String) -> Date? {
        if let dateString = fromString {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone.default
            dateFormatter.locale = NSLocale(localeIdentifier: Constant.defaultDateLocale) as Locale!
            dateFormatter.dateFormat = format
            return dateFormatter.date(from: dateString)
        } else {
            return nil
        }
    }

    static func convertStringDateToString(fromString: String?, fromFormat: String, toFormat: String) -> String? {
        if let dateString = fromString {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone.default
            dateFormatter.locale = NSLocale(localeIdentifier: Constant.defaultDateLocale) as Locale!
            dateFormatter.dateFormat = fromFormat
            guard let date = dateFormatter.date(from: dateString) else {
                return nil
            }
            dateFormatter.dateFormat = toFormat
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }

}
