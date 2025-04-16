import UIKit

final class CreateTaskPresenter {
    weak var viewController: CreateTaskViewControllerDisplayLogic?
    private let coreDataManager: CoreDataManagable
    var tasks: [TaskCellsModel]
    weak var delegate: CreateTaskPresenterDelegate?
    
    init(coreDataManager: CoreDataManagable,
         tasks: [TaskCellsModel]
    ) {
        self.coreDataManager = coreDataManager
        self.tasks = tasks
    }
}

extension CreateTaskPresenter: CreateTaskPresenterLogic {
    func updatePlaceholderVisibility(label: UILabel, textView: UITextView) {
        label.isHidden = !textView.text.isEmpty
    }
    
    func createTask(toDoTitle: String, toDoSubtitle: String) {
        if toDoTitle != "" && toDoSubtitle != "" {
            DispatchQueue.global(qos: .utility).async { [weak self] in
                guard let self = self else { return }
                let toDoDate = Date.createStringCurrrentDate()
                let newToDoId = createToDoId()
                guard let newToDoId = newToDoId else {return}
                let newTask: TaskCellsModel = TaskCellsModel(todoTitle: toDoTitle, toDoId: newToDoId, todoSubtitle: toDoSubtitle, toDoCompleted: false, toDoDate: toDoDate)
                try? coreDataManager.createToDoTask(toDoTitle: toDoTitle, toDoSubtitle: toDoSubtitle, toDoCompleted: false, toDoId: newToDoId, toDoDate: toDoDate)
                DispatchQueue.main.async {
                    self.tasks.append(newTask)
                    self.delegate?.tasksDidCreate(self.tasks)
                }
            }
        }
    }
    
    func textViewDidChange(textView: UITextView, minimalHeight: CGFloat) {
        let fixedWidth = textView.frame.width
        var newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        if newSize.height < minimalHeight {
            newSize.height = minimalHeight
        }
        viewController?.expandTitleTextView(newSize: newSize.height)
    }
    
    private func createToDoId() -> Int16? {
        guard let toDoId = try? coreDataManager.createToDoTaskId() else {return nil}
        return toDoId
    }
}
