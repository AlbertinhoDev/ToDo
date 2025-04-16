import Foundation

protocol DeleteTaskPresenterDelegate: AnyObject {
    func tasksDidDelete(_ indexPath: IndexPath)
}
