import UIKit
import CoreData

public final class CoreDataManager: NSObject {
    public static let shared = CoreDataManager()
    override init() {}
    private let context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
}

extension CoreDataManager: CoreDataManagable {
    public func createToDoTask(toDoTitle: String, toDoSubtitle: String, toDoCompleted: Bool, toDoId: Int16, toDoDate: String) throws {
        guard let toDoEntity = NSEntityDescription.entity(forEntityName: "ToDoEntity", in: context) else {
            throw CoreDataErrors.read
        }
        let toDo = ToDoEntity(entity: toDoEntity, insertInto: context)
        toDo.toDoTitle = toDoTitle
        toDo.toDoCompleted = toDoCompleted
        toDo.toDoId = toDoId
        toDo.toDoDescription = toDoSubtitle
        toDo.toDoDate = toDoDate
        try PersistenceController.shared.saveContext()
    }
    
    public func fetchToDoTasks() throws -> [ToDoEntity] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoEntity")
        do {
            return try context.fetch(fetchRequest) as! [ToDoEntity]
        } catch {
            throw CoreDataErrors.read
        }
    }
    
    public func updateToDoTask(toDoTitle: String, toDoSubtitle: String, toDoId: Int16) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoEntity")
        do {
            guard let toDoTasks = try? context.fetch(fetchRequest) as? [ToDoEntity],
            let toDoTask = toDoTasks.first(where: { $0.toDoId == toDoId }) else {
                throw CoreDataErrors.update
            }
            toDoTask.toDoTitle = toDoTitle
            toDoTask.toDoDescription = toDoSubtitle
        }
        try PersistenceController.shared.saveContext()
    }
    
    public func deleteToDoTask(toDoId: Int16) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoEntity")
        do {
            guard let toDoTasks = try? context.fetch(fetchRequest) as? [ToDoEntity],
            let toDoTask = toDoTasks.first(where: { $0.toDoId == toDoId }) else {
                throw CoreDataErrors.delete
            }
            context.delete(toDoTask)
        }
        try PersistenceController.shared.saveContext()
    }
    
    public func deleteAllToDoTask() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            throw CoreDataErrors.delete
        }
        try PersistenceController.shared.saveContext()
    }
    
    public func updateToDoTaskCompleted(toDoId: Int16) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoEntity")
        do {
            guard let toDoTasks = try? context.fetch(fetchRequest) as? [ToDoEntity],
            let toDoTask = toDoTasks.first(where: { $0.toDoId == toDoId }) else {
                throw CoreDataErrors.update
            }
            toDoTask.toDoCompleted = !toDoTask.toDoCompleted
        }
        try PersistenceController.shared.saveContext()
    }
    
    public func createToDoTaskId() throws -> Int16? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoEntity")
        do {
            guard let toDoTasks = try? context.fetch(fetchRequest) as? [ToDoEntity],
            let toDoTaskMaxId = toDoTasks.max(by: { $0.toDoId < $1.toDoId }) else {
                throw CoreDataErrors.read
            }
            return toDoTaskMaxId.toDoId + 1
        }
    }
}



