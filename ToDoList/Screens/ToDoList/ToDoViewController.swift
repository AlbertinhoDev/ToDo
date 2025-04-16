import UIKit

class ToDoViewController: UIViewController {
    var presenter: ToDoPresenterLogic?
    private let taskTableView = UITableView()
    private var sections: [Section] = []
    private lazy var commonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "FooterBackgroundColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var footerLabel: UILabel = {
        let footer = UILabel()
        footer.textColor = UIColor(named: "FooterLabel")
        footer.text = "Task"
        footer.font = .systemFont(ofSize: 11, weight: .regular)
        footer.translatesAutoresizingMaskIntoConstraints = false
        return footer
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .yellow
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createNewTask), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        presenter?.fetchDataCore()
        setupViewController()
    }
    
    @objc private func createNewTask() {
        self.presenter?.didTapCreateButton()
    }
    
    private func setupViewController() {
        view.addSubview(commonStackView)
        commonStackView.addArrangedSubview(taskTableView)
        commonStackView.addArrangedSubview(footerView)
        footerView.addSubview(footerLabel)
        footerView.addSubview(createButton)
        taskTableView.translatesAutoresizingMaskIntoConstraints = false
        taskTableView.backgroundColor = .clear
        taskTableView.showsVerticalScrollIndicator = false
        taskTableView.dataSource = self
        taskTableView.delegate = self
        taskTableView.register(TitleTableViewCell.self)
        taskTableView.register(SearchTableViewCell.self)
        taskTableView.register(TasksTableViewCell.self)
        
        NSLayoutConstraint.activate([
            commonStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            commonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            commonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.0625),
            footerLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            footerLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            createButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            createButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
        ])
    }
}

extension ToDoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let rowType = sections[section].rows[row]
        switch rowType {
        case .title:
            let cell = tableView.dequeueReusableCell(TitleTableViewCell.self, indexPath: indexPath)
            return cell
        case .search:
            let cell = tableView.dequeueReusableCell(SearchTableViewCell.self, indexPath: indexPath)
            cell.delegate = presenter.self as? any SearchDelegate
            return cell
        case .task:
            let cell = presenter?.createTasksCell(tableView: tableView, indexPath: indexPath)
            guard let cell = cell else {return UITableViewCell()}
            return cell
        }
    }
}

extension ToDoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didTapTaskCell(indexPath: indexPath)
    }
}

extension ToDoViewController: ToDoDisplayLogic {
    func deleteRow(indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.sections[indexPath.section].rows.remove(at: indexPath.row)
            self.taskTableView.deleteRows(at: [indexPath], with: .automatic)
            self.footerLabel.text = self.presenter?.createTextCount(count: self.sections[indexPath.section].rows.count)
        }
    }
    
    func update(sections: [Section]) {
        guard let result = self.presenter?.saveFocus(tableView: taskTableView) else {
            return
        }
        let (searchText, wasFirstResponder) = result
        self.sections = sections
        self.footerLabel.text = self.presenter?.createTextCount(count: sections[2].rows.count)
        self.taskTableView.reloadData()
        self.presenter?.returnFocus(tableView: taskTableView, searchText: searchText, wasFirstResponder: wasFirstResponder)
    }
}
