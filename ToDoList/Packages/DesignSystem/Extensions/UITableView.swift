import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ type: T.Type) {
        register(type, forCellReuseIdentifier: type.reuseId)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.reuseId, for: indexPath) as? T else {
            fatalError("Cell \(type) not found")
        }
        return cell
    }
}
