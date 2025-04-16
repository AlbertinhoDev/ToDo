import UIKit

protocol ToDoApiServicable {
    func loadData() async throws -> Todos
}
