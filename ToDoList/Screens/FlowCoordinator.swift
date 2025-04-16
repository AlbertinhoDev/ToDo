import UIKit

final class FlowCoordinator: TaskRoutingLogic {
    private let router: Router
    private let screenBuilder: ScreenBuildable
    private let toDoDiContainer: ToDoDiContainerable
    private let coreDataManager: CoreDataManagable
    
    init(router: Router,
         screenBuilder: ScreenBuildable = ScreenBuilder(),
         toDoDiContainer: ToDoDiContainerable = ToDoDiContainer(),
         coreDataManager: CoreDataManagable = CoreDataManager()
    ) {
        self.router = router
        self.screenBuilder = screenBuilder
        self.toDoDiContainer = toDoDiContainer
        self.coreDataManager = coreDataManager
    }
}

extension FlowCoordinator: Coordinator {
    func start() {
        let viewController = screenBuilder.makeToDoViewController(router: self, toDoDiContainer: toDoDiContainer, coreDataManager: coreDataManager)
        router.setRoot(viewController: viewController, animated: true)
    }
}

extension FlowCoordinator: ToDoRoutingLogic {
    func showTaskViewConroller(indexPath: IndexPath, delegate: DeleteTaskPresenterDelegate, tasks: [TaskCellsModel]) {
        let viewController = screenBuilder.makeTaskViewController(router: self, tasks: tasks, indexPath: indexPath, coreDataManager: coreDataManager, delegate: delegate)
        router.present(viewController: viewController, animated: true)
    }

    func showCreateTaskViewController(tasks: [TaskCellsModel], delegate: CreateTaskPresenterDelegate) {
        let viewController = screenBuilder.makeCreateTaskViewController(coreDataManager: coreDataManager, toDoDiContainer: toDoDiContainer, tasks: tasks, delegate: delegate)
        router.push(viewController, animated: true)
    }
    
    func showEditTaskViewController(tasks: [TaskCellsModel], indexPath: IndexPath, delegate: EditTaskPresenterDelegate) {
        let viewController = screenBuilder.makeEditTaskViewController(tasks: tasks, indexPath: indexPath, coreDataManager: coreDataManager, delegate: delegate)
        router.push(viewController, animated: true)
    }
}

extension FlowCoordinator: BackRoutingLogic {
    func back() {
        router.dismiss(animated: true)
    }
}
                                
