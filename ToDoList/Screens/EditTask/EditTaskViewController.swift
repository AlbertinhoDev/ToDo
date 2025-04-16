import UIKit

class EditTaskViewController: UIViewController {
    var presenter: EditTaskPresenterLogic?
    var heightTitleTextViewConstraint: NSLayoutConstraint!
    
    private lazy var titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 34, weight: .bold)
        textView.textColor = UIColor(named: "FalseText")
        textView.isScrollEnabled = false
        textView.backgroundColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.textColor = UIColor(named: "FalseText")
        textView.backgroundColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        presenter?.fillForms()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard isMovingFromParent else { return }
        presenter?.saveChange(toDoTitle: titleTextView.text, toDoSubtitle: subtitleTextView.text)
    }
    
    private func setupViewController() {
        view.backgroundColor = .black
        navigationController?.isNavigationBarHidden = false
        view.addSubview(titleTextView)
        view.addSubview(subtitleTextView)
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            subtitleTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor),
            subtitleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subtitleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        heightTitleTextViewConstraint = titleTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        heightTitleTextViewConstraint.isActive = true
    }
}

extension EditTaskViewController: EditTaskViewControllerDisplayLogic {
    func getText(titleLabel: String, subtitle: String) {
        self.titleTextView.text = titleLabel
        self.subtitleTextView.text = subtitle
    }
    
    func expandTitleTextView (newSize: CGFloat) {
        heightTitleTextViewConstraint.constant = newSize
        view.layoutIfNeeded()
    }
}

extension EditTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        presenter?.textViewDidChange(textView: titleTextView, minimalHeight: 60)
    }
}
