import UIKit

class TaskViewController: UIViewController {
    var presenter: TaskPresenterLogic?
    
    private lazy var viewSubstrate: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "FooterBackgroundColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(named: "FalseText")
        label.backgroundColor = .clear
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(named: "FalseText")
        label.backgroundColor = .clear
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(named: "TrueText")
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = .zero
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .lightGray
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 12
        return stackView
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "pencil")
        config.title = "Редактировать"
        config.imagePlacement = .trailing
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 15,
            bottom: 0,
            trailing: 15
        )
        button.configuration = config
        button.contentHorizontalAlignment = .fill
        button.configuration?.titleAlignment = .leading
        button.tintColor = .black
        button.addTarget(self, action: #selector(editTapButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "paperplane")
        config.title = "Поделиться"
        config.imagePlacement = .trailing
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 15,
            bottom: 0,
            trailing: 15
        )
        button.configuration = config
        button.contentHorizontalAlignment = .fill
        button.configuration?.titleAlignment = .leading
        button.tintColor = .black
        button.addTarget(self, action: #selector(sendTapButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "trash")
        config.title = "Удалить"
        config.imagePlacement = .trailing
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 15,
            bottom: 0,
            trailing: 15
        )
        button.configuration = config
        button.contentHorizontalAlignment = .fill
        button.configuration?.titleAlignment = .leading
        button.tintColor = .red
        button.addTarget(self, action: #selector(deleteTapButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        presenter?.fillForms()
    }
    
    private func setupViewController() {
        view.backgroundColor = .black.withAlphaComponent(0.8)
        view.addSubview(viewSubstrate)
        view.addSubview(buttonStackView)
        viewSubstrate.addSubview(textStackView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(subtitleLabel)
        textStackView.addArrangedSubview(dateLabel)
        buttonStackView.addArrangedSubview(editButton)
        buttonStackView.addArrangedSubview(sendButton)
        buttonStackView.addArrangedSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            viewSubstrate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewSubstrate.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewSubstrate.widthAnchor.constraint(lessThanOrEqualToConstant: view.bounds.width),
            textStackView.topAnchor.constraint(equalTo: viewSubstrate.topAnchor, constant: 16),
            textStackView.bottomAnchor.constraint(equalTo: viewSubstrate.bottomAnchor, constant: -16),
            textStackView.leadingAnchor.constraint(equalTo: viewSubstrate.leadingAnchor, constant: 16),
            textStackView.trailingAnchor.constraint(equalTo: viewSubstrate.trailingAnchor, constant: -16),
            buttonStackView.topAnchor.constraint(equalTo: viewSubstrate.bottomAnchor, constant: 16),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.widthAnchor.constraint(equalToConstant: 0.7 * view.bounds.width),
            buttonStackView.heightAnchor.constraint(equalToConstant: 0.165 * view.bounds.height),
        ])
    }
    
    @objc private func editTapButton() {
        presenter?.edit()
    }
    
    @objc private func sendTapButton() {
        presenter?.send()
    }
    
    @objc private func deleteTapButton() {
        presenter?.delete()
    }
}

extension TaskViewController: TaskViewControllerDisplayLogic {
    func presentActivity(activityVC: UIActivityViewController, animated: Bool) {
        present(activityVC, animated: animated)
    }
    
    func getText(titleLabel: String, subtitle: String, date: String) {
        self.titleLabel.text = titleLabel
        self.subtitleLabel.text = subtitle
        self.dateLabel.text = date
    }
}
