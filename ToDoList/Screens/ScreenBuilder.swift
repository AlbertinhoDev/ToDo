import UIKit

final class ScreenBuilder {}

extension ScreenBuilder: ScreenBuildable {
    func makeToDoViewController(router: ToDoRoutingLogic, toDoDiContainer: ToDoDiContainerable, coreDataManager: CoreDataManagable) -> UIViewController {
        let viewController = ToDoViewController()
        let presenter = ToDoPresenter(toDoApiService: toDoDiContainer.toDoApiService, coreDataManager: coreDataManager)
        viewController.presenter = presenter
        presenter.viewController = viewController
        presenter.router = router
        return viewController
    }
    
    func makeCreateTaskViewController(coreDataManager: CoreDataManagable, toDoDiContainer: ToDoDiContainerable, tasks: [TaskCellsModel], delegate: CreateTaskPresenterDelegate) -> UIViewController {
        let viewController = CreateTaskViewController()
        let presenter = CreateTaskPresenter(coreDataManager: coreDataManager, tasks: tasks)
        viewController.presenter = presenter
        presenter.viewController = viewController
        presenter.delegate = delegate 
        return viewController
    }
    
    func makeTaskViewController(router: TaskRoutingLogic, tasks: [TaskCellsModel], indexPath: IndexPath, coreDataManager: CoreDataManagable, delegate: DeleteTaskPresenterDelegate) -> UIViewController {
        let viewController = TaskViewController()
        let presenter = TaskPresenter(coreDataManager: coreDataManager, tasks: tasks, indexPath: indexPath)
        viewController.presenter = presenter
        presenter.viewController = viewController
        presenter.delegate = delegate
        presenter.router = router
        return viewController
    }
    
    func makeEditTaskViewController(tasks: [TaskCellsModel], indexPath: IndexPath, coreDataManager: CoreDataManagable, delegate: EditTaskPresenterDelegate) -> UIViewController {
        let viewController = EditTaskViewController()
        let presenter = EditTaskPresenter(coreDataManager: coreDataManager, tasks: tasks, indexPath: indexPath)
        viewController.presenter = presenter
        presenter.viewController = viewController
        presenter.delegate = delegate
        return viewController
    }
}
