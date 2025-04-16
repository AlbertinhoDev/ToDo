import UIKit

protocol CoreDataManagable {
    func createToDoTask(toDoTitle: String, toDoSubtitle: String, toDoCompleted: Bool, toDoId: Int16, toDoDate: String) throws
    func fetchToDoTasks() throws -> [ToDoEntity] 
    func updateToDoTask(toDoTitle: String, toDoSubtitle: String, toDoId: Int16) throws
    func updateToDoTaskCompleted(toDoId: Int16) throws
    func deleteToDoTask(toDoId: Int16) throws
    func deleteAllToDoTask() throws
    func createToDoTaskId() throws -> Int16?
}
