import UIKit

extension Date {
    static func createStringCurrrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
}
