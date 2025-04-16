import UIKit

protocol TaskViewControllerDisplayLogic: AnyObject {
    func getText(titleLabel: String, subtitle: String, date: String)
    func presentActivity(activityVC: UIActivityViewController, animated: Bool)
}
