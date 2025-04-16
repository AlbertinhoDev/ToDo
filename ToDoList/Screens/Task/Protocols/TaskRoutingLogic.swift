import UIKit

protocol TaskRoutingLogic: BackRoutingLogic {
    func showEditTaskViewController(tasks: [TaskCellsModel], indexPath: IndexPath, delegate: EditTaskPresenterDelegate)
}
