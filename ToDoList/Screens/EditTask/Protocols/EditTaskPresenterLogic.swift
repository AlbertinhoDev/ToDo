import UIKit

protocol EditTaskPresenterLogic {
    func textViewDidChange(textView: UITextView, minimalHeight: CGFloat)
    func fillForms()
    func saveChange(toDoTitle: String, toDoSubtitle: String)
}

