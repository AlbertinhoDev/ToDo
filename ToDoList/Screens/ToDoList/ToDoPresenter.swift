import UIKit

final class ToDoPresenter {
    weak var viewController: ToDoDisplayLogic?
    var router: ToDoRoutingLogic?
    private let toDoApiService: ToDoApiServicable
    private let coreDataManager: CoreDataManagable
    private var flag: Bool = true
    private var originTasks: [TaskCellsModel] = []
    private var tasks: [TaskCellsModel] = [] {
        didSet {
            if flag {
                originTasks = tasks
            }
        }
    }
    
    init(
        toDoApiService: ToDoApiServicable,
        coreDataManager: CoreDataManagable
    ) {
        self.toDoApiService = toDoApiService
        self.coreDataManager = coreDataManager
    }
}

extension ToDoPresenter: ToDoPresenterLogic {
    func fetchDataCore() {
        let dataCount = try? CoreDataManager.shared.fetchToDoTasks().count
        switch dataCount {
        case 0:
            loadData()
        default:
            buildingTableView()
        }
    }
    
    func createTextCount(count: Int) -> String {
        let lastDigit = count % 10
        switch lastDigit {
        case 0, 5, 6, 7, 8, 9:
            return "\(count) Задач"
        case 1:
            return "\(count) Задача"
        case 2...4:
            return "\(count) Задачи"
        default:
            return "Задачи"
        }
    }
    
    func didTapCreateButton() {
        router?.showCreateTaskViewController(tasks: tasks, delegate: self)
    }
    
    func createTasksCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TasksTableViewCell.self, indexPath: indexPath)
        let task = tasks[indexPath.row]
        cell.configureCell(with: task)
        cell.onStatusButtonTapped = { [weak self] task in
            self?.updateStatus(task: task, indexPath: indexPath, completion: { result in
                cell.configureCell(with: result)
                self?.tasks[indexPath.row].toDoCompleted = result.toDoCompleted
                if let index = self?.originTasks.firstIndex(where: { $0.toDoId == result.toDoId }) {
                    self?.originTasks[index].toDoCompleted = result.toDoCompleted
                }
            })
        }
        return cell
    }
    
    func didTapTaskCell(indexPath: IndexPath) {
        router?.showTaskViewConroller(indexPath: indexPath, delegate: self, tasks: tasks)
    }
    
    func saveFocus(tableView: UITableView) -> (searchText: String, wasFirstResponder: Bool) {
        var searchText = ""
        var wasFirstResponder = false
        if let searchCell = tableView.visibleCells.first(where: { $0 is SearchTableViewCell }) as? SearchTableViewCell {
            (searchText, wasFirstResponder) = searchCell.currentSearchState()
        }
        return (searchText, wasFirstResponder)
    }
    
    func returnFocus(tableView: UITableView, searchText: String, wasFirstResponder: Bool) {
        DispatchQueue.main.async {
            if let newSearchCell = tableView.visibleCells.first(where: { $0 is SearchTableViewCell }) as? SearchTableViewCell {
                newSearchCell.restoreSearchState(text: searchText, shouldBecomeFirstResponder: wasFirstResponder)
            }
        }
    }
    
    private func loadData() {
        Task {
            do {
                let response = try await toDoApiService.loadData()
                saveInCoreData(response: response)
                await MainActor.run {
                    buildingTableView()
                }
            } catch {
                await MainActor.run {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func saveInCoreData(response: Todos) {
        let toDoDate = Date.createStringCurrrentDate()
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            do {
                response.todos.forEach { item in
                    try? self.coreDataManager.createToDoTask(toDoTitle: item.todo, toDoSubtitle: item.todo, toDoCompleted: item.completed, toDoId: Int16(item.id), toDoDate: toDoDate)
                }
            }
        }
    }
    
    private func buildingTableView() {
        tasks = createTasksArray()
        createTableView(tasks: tasks)
    }
    
    private func createTasksArray() -> [TaskCellsModel]{
        self.tasks = []
        guard let fetchToDoTasks = try? coreDataManager.fetchToDoTasks() else {
            return []
        }
        for toDoTask in fetchToDoTasks {
            tasks.append(TaskCellsModel(todoTitle: toDoTask.toDoTitle, toDoId: toDoTask.toDoId, todoSubtitle: toDoTask.toDoDescription, toDoCompleted: toDoTask.toDoCompleted, toDoDate: toDoTask.toDoDate))
        }
        return tasks
    }
    
    private func updateStatus(task: TaskCellsModel, indexPath: IndexPath, completion: @escaping (TaskCellsModel) -> Void) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            try? coreDataManager.updateToDoTaskCompleted(toDoId: task.toDoId)
            self.tasks[indexPath.row].toDoCompleted = !self.tasks[indexPath.row].toDoCompleted
            DispatchQueue.main.async {
                completion(self.tasks[indexPath.row])
            }
        }
    }
    
    private func createTableView(tasks: [TaskCellsModel]) {
        let sections: [Section]  = [
            .init(type: .title, rows: [.title]),
            .init(type: .search, rows: [.search]),
            .init(type: .tasks, rows: Array(repeating: .task, count: tasks.count))
        ]
        viewController?.update(sections: sections)
    }
    
    private func filterTasks(searchText: String) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            if searchText.isEmpty {
                DispatchQueue.main.async {
                    self.flag = true
                    self.tasks = self.originTasks
                    self.createTableView(tasks: self.tasks)
                }
            } else {
                let filteredTasks = tasks.filter {
                    return $0.todoTitle.lowercased().contains(searchText.lowercased()) || $0.todoSubtitle.lowercased().contains(searchText.lowercased())
                }
                DispatchQueue.main.async {
                    self.flag = false
                    self.tasks = filteredTasks
                    self.createTableView(tasks: filteredTasks)
                }
            }
        }
    }
}

extension ToDoPresenter: DeleteTaskPresenterDelegate {
    func tasksDidDelete(_ indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)
        viewController?.deleteRow(indexPath: indexPath)
    }
}

extension ToDoPresenter: CreateTaskPresenterDelegate {
    func tasksDidCreate(_ tasks: [TaskCellsModel]) {
        self.tasks = tasks
        createTableView(tasks: tasks)
    }
}

extension ToDoPresenter: EditTaskPresenterDelegate {
    func tasksDidEdit(_ tasks: [TaskCellsModel]) {
        self.tasks = tasks
        createTableView(tasks: tasks)
    }
}

extension ToDoPresenter: SearchDelegate {
    func searchTask(searchText: String) {
        filterTasks(searchText: searchText)
    }
}
