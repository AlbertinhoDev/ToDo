import UIKit

protocol ToDoRoutingLogic {
    func showCreateTaskViewController(tasks: [TaskCellsModel], delegate: CreateTaskPresenterDelegate)
    func showTaskViewConroller(indexPath: IndexPath, delegate: DeleteTaskPresenterDelegate, tasks: [TaskCellsModel])
}
