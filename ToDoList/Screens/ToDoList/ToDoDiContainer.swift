import UIKit

final class ToDoDiContainer: ToDoDiContainerable {
    var toDoApiService: ToDoApiServicable
    
    init(toDoApiService: ToDoApiServicable = ToDoApiService()) {
        self.toDoApiService = toDoApiService
    }
}
