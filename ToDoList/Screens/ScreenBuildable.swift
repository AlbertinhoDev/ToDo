import UIKit

protocol ScreenBuildable {
    func makeToDoViewController(router: ToDoRoutingLogic, toDoDiContainer: ToDoDiContainerable, coreDataManager: CoreDataManagable) -> UIViewController
    
    func makeCreateTaskViewController(coreDataManager: CoreDataManagable, toDoDiContainer: ToDoDiContainerable, tasks: [TaskCellsModel], delegate: CreateTaskPresenterDelegate) -> UIViewController
    
    func makeTaskViewController(router: TaskRoutingLogic, tasks: [TaskCellsModel], indexPath: IndexPath, coreDataManager: CoreDataManagable, delegate: DeleteTaskPresenterDelegate) -> UIViewController
    
    func makeEditTaskViewController(tasks: [TaskCellsModel], indexPath: IndexPath, coreDataManager: CoreDataManagable, delegate: EditTaskPresenterDelegate) -> UIViewController
}
