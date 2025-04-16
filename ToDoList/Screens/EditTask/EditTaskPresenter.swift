import UIKit

final class EditTaskPresenter {
    weak var viewController: EditTaskViewControllerDisplayLogic?
    weak var delegate: EditTaskPresenterDelegate?
    private let coreDataManager: CoreDataManagable
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

extension EditTaskPresenter: EditTaskPresenterLogic {
    func textViewDidChange(textView: UITextView, minimalHeight: CGFloat) {
        let fixedWidth = textView.frame.width
        var newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        if newSize.height < minimalHeight {
            newSize.height = minimalHeight
        }
        viewController?.expandTitleTextView(newSize: newSize.height)
    }
    
    func fillForms() {
        viewController?.getText(titleLabel: tasks[indexPath.row].todoTitle, subtitle: tasks[indexPath.row].todoSubtitle)
    }
    
    func saveChange(toDoTitle: String, toDoSubtitle: String) {
        if toDoTitle == "" && toDoSubtitle == "" {
            return
        }
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            try? coreDataManager.updateToDoTask(toDoTitle: toDoTitle, toDoSubtitle: toDoSubtitle, toDoId: Int16(tasks[indexPath.row].toDoId))
            self.tasks[self.indexPath.row].todoTitle = toDoTitle
            self.tasks[self.indexPath.row].todoSubtitle = toDoSubtitle
            DispatchQueue.main.async {
                self.delegate?.tasksDidEdit(self.tasks)
            }
        }
    }
}
