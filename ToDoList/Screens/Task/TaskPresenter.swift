import UIKit

final class TaskPresenter {
    weak var viewController: TaskViewControllerDisplayLogic?
    var router: TaskRoutingLogic?
    private let coreDataManager: CoreDataManagable
    weak var delegate: DeleteTaskPresenterDelegate?
    var indexPath: IndexPath
    var tasks: [TaskCellsModel]
    
    init(coreDataManager: CoreDataManagable,
         tasks: [TaskCellsModel],
         indexPath: IndexPath
    ) {
        self.coreDataManager = coreDataManager
        self.tasks = tasks
        self.indexPath = indexPath
    }
}

extension TaskPresenter: TaskPresenterLogic {
    func edit() {
        router?.showEditTaskViewController(tasks: tasks, indexPath: indexPath, delegate: delegate as! EditTaskPresenterDelegate)
        self.router?.back()
    }
    
    func delete() {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            
            try? coreDataManager.deleteToDoTask(toDoId: self.tasks[indexPath.row].toDoId)
            DispatchQueue.main.async {
                self.delegate?.tasksDidDelete(self.indexPath)
                self.router?.back()
            }
        }
    }
    
    func send() {
        let todoTitle = tasks[indexPath.row].todoTitle
        let todoSubtitle = tasks[indexPath.row].todoSubtitle
        let toDoDate = tasks[indexPath.row].toDoDate
        let toDoId = tasks[indexPath.row].toDoId
        let toDoCompleted = tasks[indexPath.row].toDoCompleted
        let items: [Any] = [todoTitle, todoSubtitle, toDoDate, toDoId, toDoCompleted]
        
        let activityVC = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        
        activityVC.excludedActivityTypes = [
            .addToReadingList,
            .assignToContact
        ]
        viewController?.presentActivity(activityVC: activityVC, animated: true)
    }
    
    func fillForms() {
        viewController?.getText(titleLabel: tasks[indexPath.row].todoTitle, subtitle: tasks[indexPath.row].todoSubtitle, date: tasks[indexPath.row].toDoDate)
    }
}
