import UIKit

final class TasksTableViewCell: UITableViewCell {

    private var currentTask: TaskCellsModel?
    var onStatusButtonTapped: ((TaskCellsModel) -> Void)?
    
    private lazy var commonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var statusButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapStatusButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var toDoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var toDoSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var currentDateStringLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @objc private func didTapStatusButton() {
        guard let task = currentTask else { return }
        onStatusButtonTapped?(task)
    }
    
    func configureCell(with model: TaskCellsModel) {
        let attributes = setTextFormat(flag: model.toDoCompleted)
        toDoTitleLabel.attributedText = NSAttributedString(string: model.todoTitle, attributes: attributes)
        toDoSubtitleLabel.attributedText = NSAttributedString(string: model.todoSubtitle, attributes: attributes)
        currentDateStringLabel.attributedText = NSAttributedString(string: model.toDoDate, attributes: attributes)
        if model.toDoCompleted == false {
            statusButton.setImage(UIImage(systemName: "circle"), for: .normal)
            statusButton.tintColor = UIColor(named: "FalseText")
        } else {
            statusButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            statusButton.tintColor = .yellow
        }
        currentTask = model
    }
    
    private func setupCell() {
        backgroundColor = .clear
        contentView.addSubview(commonStackView)
        commonStackView.addArrangedSubview(statusButton)
        commonStackView.addArrangedSubview(textStackView)
        textStackView.addArrangedSubview(toDoTitleLabel)
        textStackView.addArrangedSubview(toDoSubtitleLabel)
        textStackView.addArrangedSubview(currentDateStringLabel)
        
        NSLayoutConstraint.activate([
            commonStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            commonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            commonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            commonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            statusButton.widthAnchor.constraint(equalToConstant: 24),
            statusButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    private func setTextFormat(flag: Bool) -> [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = [:]
        if flag == false {
            attributes = [
                .foregroundColor: UIColor(named: "FalseText") ?? .white
            ]
        } else {
            attributes = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: UIColor(named: "TrueText") ?? .gray,
                .foregroundColor: UIColor(named: "TrueText") ?? .gray
            ]
        }
        return attributes
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
