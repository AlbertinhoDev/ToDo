import Foundation

protocol EditTaskPresenterDelegate: AnyObject {
    func tasksDidEdit(_ tasks: [TaskCellsModel])
}
