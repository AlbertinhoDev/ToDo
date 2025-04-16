import UIKit

extension UITableViewCell {
    static var reuseId: String {
        return String(describing: self)
    }
}
