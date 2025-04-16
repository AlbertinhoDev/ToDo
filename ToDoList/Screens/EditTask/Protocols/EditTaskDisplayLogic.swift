import UIKit

protocol EditTaskViewControllerDisplayLogic: AnyObject {
    func expandTitleTextView (newSize: CGFloat)
    func getText(titleLabel: String, subtitle: String)
}
