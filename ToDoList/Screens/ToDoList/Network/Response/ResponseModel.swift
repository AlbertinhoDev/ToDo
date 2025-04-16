import UIKit

struct Todos: Decodable {
    let todos: [TodosModel]
}

struct TodosModel: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
}
