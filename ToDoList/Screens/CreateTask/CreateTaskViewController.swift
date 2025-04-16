import UIKit

class CreateTaskViewController: UIViewController {
    var presenter: CreateTaskPresenterLogic?
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
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(named: "TrueText")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Date.createStringCurrrentDate()
        return label
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
    
    let placeholderTitleTextView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Заголовок..."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    let placeholderSubtitleTextView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Описание..."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupTextView()
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard isMovingFromParent else { return }
        presenter?.createTask(toDoTitle: titleTextView.text, toDoSubtitle: subtitleTextView.text)
    }
    
    private func setupViewController() {
        view.backgroundColor = .black
        view.addSubview(titleTextView)
        view.addSubview(dateLabel)
        view.addSubview(subtitleTextView)
        view.addSubview(placeholderTitleTextView)
        view.addSubview(placeholderSubtitleTextView)
        
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dateLabel.heightAnchor.constraint(equalToConstant: 16),
            subtitleTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            subtitleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subtitleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            placeholderTitleTextView.topAnchor.constraint(equalTo: titleTextView.topAnchor, constant: 8),
            placeholderTitleTextView.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor, constant: 5),
            placeholderSubtitleTextView.topAnchor.constraint(equalTo: subtitleTextView.topAnchor, constant: 8),
            placeholderSubtitleTextView.leadingAnchor.constraint(equalTo: subtitleTextView.leadingAnchor, constant: 5)
        ])
        
        heightTitleTextViewConstraint = titleTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        heightTitleTextViewConstraint.isActive = true
    }
    
    private func setupTextView() {
        titleTextView.delegate = self
        subtitleTextView.delegate = self
    }
}

extension CreateTaskViewController: CreateTaskViewControllerDisplayLogic {
    func expandTitleTextView (newSize: CGFloat) {
        heightTitleTextViewConstraint.constant = newSize
        view.layoutIfNeeded()
    }
}

extension CreateTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        presenter?.textViewDidChange(textView: titleTextView, minimalHeight: 60)
        presenter?.updatePlaceholderVisibility(label: placeholderTitleTextView, textView: titleTextView)
        presenter?.updatePlaceholderVisibility(label: placeholderSubtitleTextView, textView: subtitleTextView)
    }
}

