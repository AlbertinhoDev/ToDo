import UIKit

protocol ToDoDisplayLogic: AnyObject {
    func update(sections: [Section])
    func deleteRow(indexPath: IndexPath)
}
