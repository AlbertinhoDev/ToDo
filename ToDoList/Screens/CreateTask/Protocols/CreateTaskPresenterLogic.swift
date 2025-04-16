import UIKit

protocol CreateTaskPresenterLogic {
    func textViewDidChange(textView: UITextView, minimalHeight: CGFloat)
    func updatePlaceholderVisibility(label: UILabel, textView: UITextView)
    func createTask(toDoTitle: String, toDoSubtitle: String)
}

