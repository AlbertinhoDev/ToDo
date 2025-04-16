import Foundation
import CoreData

@objc(ToDoEntity)
public class ToDoEntity: NSManagedObject {}

extension ToDoEntity {
    @NSManaged public var toDoTitle: String
    @NSManaged public var toDoDescription: String
    @NSManaged public var toDoCompleted: Bool
    @NSManaged public var toDoId: Int16
    @NSManaged public var toDoDate: String
}

extension ToDoEntity : Identifiable {}
