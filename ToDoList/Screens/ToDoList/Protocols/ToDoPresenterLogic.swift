import UIKit

protocol ToDoPresenterLogic {
    func didTapCreateButton()
    func didTapTaskCell(indexPath: IndexPath)
    func fetchDataCore()
    func createTextCount(count: Int) -> String
    func createTasksCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell  
    func saveFocus(tableView: UITableView) -> (searchText: String, wasFirstResponder: Bool)
    func returnFocus(tableView: UITableView, searchText: String, wasFirstResponder: Bool)
}
